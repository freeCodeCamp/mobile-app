import 'dart:convert';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/dom.dart' as dom;

class TestRunner extends BaseViewModel {
  String _testDocument = '';
  String get testDocument => _testDocument;

  set setTestDocument(String document) {
    _testDocument = document;
    notifyListeners();
  }

  // This function returns a specific file content from the cache.
  // If testing is enabled on the function it will return
  // the first file with the given file name.

  Future<String> getExactFileFromCache(
    Challenge challenge,
    ChallengeFile file, {
    bool testing = false,
  }) async {
    String? cache;

    if (testing) {
      cache = challenge.files
          .firstWhere((element) => element.name == file.name)
          .contents;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cache = prefs.getString('${challenge.title}.${file.name}');
    }

    return cache ?? '';
  }

  // This funciton returns the first file content with the given extension from the
  // cache. If testing is enabled it will return the file directly from the challenge.
  // If a CSS extension is put as a parameter it will return the first HTML file instead.

  Future<String> getFirstFileFromCache(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    String fileContent = '';

    if (testing) {
      List<ChallengeFile> firstHtmlChallenge = challenge.files
          .where((file) => (file.ext == Ext.css || file.ext == Ext.html)
              ? file.ext == Ext.html
              : file.ext == ext)
          .toList();
      fileContent = firstHtmlChallenge[0].contents;
    } else {
      List<ChallengeFile> firstHtmlChallenge = challenge.files
          .where((file) => (file.ext == Ext.css || file.ext == Ext.html)
              ? file.ext == Ext.html
              : file.ext == ext)
          .toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      fileContent =
          prefs.getString('${challenge.title}.${firstHtmlChallenge[0].name}') ??
              firstHtmlChallenge[0].contents;
    }

    return fileContent;
  }

  // This function checks if the given document contains any link elements.
  // If so check if the css file name corresponds with the names put in the array.
  // If the file is linked return true.

  Future<bool> cssFileIsLinked(
    String document,
    String cssFileName,
  ) async {
    dom.Document doc = parse(document);

    List<dom.Node> links = doc.getElementsByTagName('LINK');

    List<String> linkedFileNames = [];

    if (links.isNotEmpty) {
      for (dom.Node node in links) {
        if (node.attributes['href'] == null) continue;

        if (node.attributes['href']!.contains('/')) {
          linkedFileNames.add(node.attributes['href']!.split('/').last);
        } else if (node.attributes['href']!.isNotEmpty) {
          linkedFileNames.add(node.attributes['href'] as String);
        }
      }
    }

    return linkedFileNames.contains(cssFileName);
  }

  // This function puts the given css content in the same file as the HTML content.
  // It will parse the current CSS content into style tags only if it is linked.
  // If there is nothing to parse it will return the plain content document.

  Future<String> parseCssDocmentsAsStyleTags(
    Challenge challenge,
    String content, {
    bool testing = false,
  }) async {
    List<ChallengeFile> cssFiles =
        challenge.files.where((element) => element.ext == Ext.css).toList();
    List<String> cssFilesWithCache = [];
    List<String> tags = [];

    if (cssFiles.isNotEmpty) {
      for (ChallengeFile file in cssFiles) {
        String? cache = await getExactFileFromCache(
          challenge,
          file,
          testing: testing,
        );

        if (!await cssFileIsLinked(
          content,
          '${file.name}.${file.ext.name}',
        )) {
          continue;
        }

        String handledFile = cache;

        cssFilesWithCache.add(handledFile);
      }

      for (String contents in cssFilesWithCache) {
        String tag = '<style> $contents </style>';
        tags.add(tag);
      }

      for (String tag in tags) {
        content += tag;
      }

      return content;
    }

    return content;
  }

  // This function sets the webview content, and parses the document accordingly.
  // It will create a new empty document. (There is no content set from
  // the actual user as this is imported in the script that tests inside the document)

  Future<String> setWebViewContent(
    Challenge challenge, {
    WebViewController? webviewController,
    bool testing = false,
  }) async {
    dom.Document document = dom.Document();
    document = parse('');

    List<String> imports = [
      '<script src="https://unpkg.com/chai/chai.js"></script>',
      '<script src="https://unpkg.com/mocha/mocha.js"></script>',
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>',
      '<link rel="stylesheet" href="https://unpkg.com/mocha/mocha.css" />'
    ];

    for (String import in imports) {
      dom.Document importToNode = parse(import);

      dom.Node node =
          importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.getElementsByTagName('HEAD')[0].append(node);
    }

    String? script = await returnScript(
      challenge.files[0].ext,
      challenge,
      testing: testing,
    );

    if (script == null) {
      throwError(challenge, 'an empty script was returned');
    }

    dom.Document scriptToNode = parse(script);

    dom.Node bodyNode =
        scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
            ? scriptToNode.getElementsByTagName('BODY').first.children.first
            : scriptToNode.getElementsByTagName('HEAD').first.children.first;

    document.body!.append(bodyNode);

    if (!testing) {
      webviewController!.loadUrl(Uri.dataFromString(
        document.outerHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString());
    }

    return document.outerHtml;
  }

  // The parse test function will parse RegEx's and Comments and more for the eval function.
  // Cause the code is going through runtime twice, the already escaped '\\' need to be escaped
  // again.

  List<String> parseTest(List<ChallengeTest> test) {
    List<String> parsedTest = test
        .map((e) =>
            """`${e.javaScript.replaceAll('\\', '\\\\').replaceAll('`', '\\`')}`""")
        .toList();

    return parsedTest;
  }

  // This funciton adds certain JavaScript code to the content document (for js challenges).
  // This is to test certain aspects of challenges. The "Head" string is added to the beginning and
  // the tail is contactenated to the end of the content string. Cause freeCodeCamp only has challenges
  // that include one javaScript file it wil always return the first file.
  // There is no need to get the exact file from the cache as only the head and tail
  // of the specific challenge are used.

  Future<String> parseHeadAndTailCode(
    String content,
    Challenge challenge, {
    bool testing = false,
  }) async {
    ChallengeFile? file = challenge.files[0];

    String head = file.head ?? '';
    String tail = file.tail ?? '';

    return '$head\n${content.replaceAll('\\', '\\\\')}\n$tail';
  }

  // This function is used in the returnScript function to correctly parse
  // HTML challenge (user code) it will firstly get the file from the cache, (it returns the first challenge file if in testing mode)
  // Otherwise it will return the first instance of that challenge in the cache. Next will be adding the style tags (only if
  // linked)

  Future<String> htmlFlow(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    String firstHTMlfile = await getFirstFileFromCache(
      challenge,
      ext,
      testing: testing,
    );

    String parsedWithStyleTags = await parseCssDocmentsAsStyleTags(
      challenge,
      firstHTMlfile,
      testing: testing,
    );

    return parsedWithStyleTags;
  }

  // This function parses the JavaScript code so that it has a head and tail (code)
  // It is used in the returnScript function to correctly parse JavaScript.

  Future<String> javaScritpFlow(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    String parseHeadAndTail = await parseHeadAndTailCode(
      challenge.files[0].contents,
      challenge,
      testing: testing,
    );

    return parseHeadAndTail;
  }

  // This is a debug function, it can be used to display a custom message in the test runner.

  void throwError(Challenge challenge, String message) {
    throw Exception(
      '''$message, debug info: ${challenge.superBlock}, ${challenge.block}, id: ${challenge.id},
         slug: ${challenge.slug.isEmpty ? 'empty' : challenge.slug},
         extension: ${challenge.files.map((e) => e.ext.name).toString()}''',
    );
  }

  // This returns the script that needs to be run in the DOM. If the test in the document fail it will
  // log the failed test to the console. If the test have been completed, it will return "completed" in a
  // console.log

  Future<String?> returnScript(
    Ext ext,
    Challenge challenge, {
    bool testing = false,
  }) async {
    String logFunction = testing ? 'console.log' : 'Print.postMessage';

    List<ChallengeFile>? indexFile =
        challenge.files.where((element) => element.name == 'index').toList();

    String? code;

    if (ext == Ext.html || ext == Ext.css) {
      code = await htmlFlow(
        challenge,
        ext,
        testing: testing,
      );
    } else if (ext == Ext.js) {
      code = await javaScritpFlow(
        challenge,
        ext,
        testing: testing,
      );
    } else {
      throwError(
        challenge,
        'this extension is not supported',
      );
    }

    if (ext == Ext.html || ext == Ext.css) {
      String? tail = challenge.files[0].tail ?? '';

      return '''<script type="module">
    import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

    const code = `$code`;
    const doc = new DOMParser().parseFromString(code, 'text/html');
  
    ${tail.isNotEmpty ? """
    const parseTail  = new DOMParser().parseFromString(`${tail.replaceAll('/', '\\/')}`,'text/html');
    const tail = parseTail.getElementsByTagName('SCRIPT')[0].innerHTML;
    """ : ''}

    const assert = chai.assert;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''"${e.instruction.replaceAll('"', '\\"').replaceAll('\n', ' ')}"''').toList().toString()};

    function getUserInput(returnCase){
      switch(returnCase){
        case 'index':
          return `${indexFile.isNotEmpty ? await getExactFileFromCache(challenge, indexFile[0], testing: testing) : "empty string"}`;
        case 'editableContents':
          return `${indexFile.isNotEmpty ? await getExactFileFromCache(challenge, indexFile[0], testing: testing) : "empty string"}`;
        default:
          return code;
      }
     }

    doc.__runTest = async function runtTests(testString) {
      let error = false;
      for(let i = 0; i < testString.length; i++){

        try {
        const testPromise = new Promise((resolve, reject) => {
          try {
            const test = eval(${tail.isNotEmpty ? 'tail + "\\n" +' : ""} testString[i]);
            resolve(test);
          } catch (e) {
            reject(e);
          }
        });

        const test = await testPromise;
        if (typeof test === "function") {
          await test(getUserInput(""));
        }
      } catch (e) {
       $logFunction(testText[i]);
       break;
      } finally {
        if(!error && testString.length -1 == i){
          $logFunction('completed');
        }
      }
      }
    };

    document.querySelector('*').innerHTML = code;
    doc.__runTest(tests);
  </script>''';
    } else if (ext == Ext.js) {
      return '''<script type="module">
      import * as __helpers from "https://unpkg.com/@freecodecamp/curriculum-helpers@1.1.0/dist/index.js";

      const assert = chai.assert;

      let code = `$code`;
      let tests = ${parseTest(challenge.tests)};

      const testText = ${challenge.tests.map((e) => '''"${e.instruction.replaceAll('"', '\\"')}"''').toList().toString()};
      function getUserInput(returnCase){
        switch(returnCase){
          case 'index':
            return `${indexFile.isNotEmpty ? await getExactFileFromCache(challenge, indexFile[0], testing: testing) : "empty string"}`;
          case 'editableContents':
            return `${indexFile.isNotEmpty ? await getExactFileFromCache(challenge, indexFile[0], testing: testing) : "empty string"}`;
          default:
            return code;
        }
      }

      try {
        for (let i = 0; i < tests.length; i++) {
          try {
            await eval(code + '\\n' + tests[i]);
          } catch (e) {
            $logFunction(testText[i]);
            break;
          }

          if(i == tests.length - 1){
            $logFunction('completed');
          }

        }
      } catch (e) {
        $logFunction(e);
      }''';
    }
    return null;
  }
}
