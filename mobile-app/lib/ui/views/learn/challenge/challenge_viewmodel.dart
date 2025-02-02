import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/test_runner.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChallengeViewModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

  String _currentSelectedFile = '';
  String get currentSelectedFile => _currentSelectedFile;

  bool _showPreview = false;
  bool get showPreview => _showPreview;

  bool _showProjectPreview = false;
  bool get showProjectPreview => _showProjectPreview;

  bool _showConsole = false;
  bool get showConsole => _showConsole;

  bool _hideAppBar = true;
  bool get hideAppBar => _hideAppBar;

  String _hint = '';
  String get hint => _hint;

  bool _showPanel = true;
  bool get showPanel => _showPanel;

  bool _runningTests = false;
  bool get runningTests => _runningTests;

  bool _afterFirstTest = false;
  bool get afterFirstTest => _afterFirstTest;

  bool _completedChallenge = false;
  bool get completedChallenge => _completedChallenge;

  PanelType _panelType = PanelType.instruction;
  PanelType get panelType => _panelType;

  InAppWebViewController? _webviewController;
  InAppWebViewController? get webviewController => _webviewController;

  InAppWebViewController? _testController;
  InAppWebViewController? get testController => _testController;

  List<ConsoleMessage> _consoleMessages = [];
  List<ConsoleMessage> get consoleMessages => _consoleMessages;

  List<ConsoleMessage> _userConsoleMessages = [];
  List<ConsoleMessage> get userConsoleMessages => _userConsoleMessages;

  Syntax _currFileType = Syntax.HTML;
  Syntax get currFileType => _currFileType;

  bool _mounted = false;

  TestRunner runner = TestRunner();

  SnackbarService snackbar = locator<SnackbarService>();
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;

  Block? _block;
  Block? get block => _block;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  EditorOptions defaultEditorOptions = EditorOptions();

  final _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final LearnFileService fileService = locator<LearnFileService>();
  final LearnService learnService = locator<LearnService>();
  final learnOfflineService = locator<LearnOfflineService>();

  final _dio = DioService.dio;

  set setCurrentSelectedFile(String value) {
    _currentSelectedFile = value;
    notifyListeners();
  }

  set setIsRunningTests(bool value) {
    _runningTests = value;
    notifyListeners();
  }

  set setAfterFirstTest(bool value) {
    _afterFirstTest = value;
    notifyListeners();
  }

  set setTestController(InAppWebViewController controller) {
    _testController = controller;
    notifyListeners();
  }

  set setHideAppBar(bool value) {
    _hideAppBar = value;
    notifyListeners();
  }

  set setShowPanel(bool value) {
    _showPanel = value;
    notifyListeners();
  }

  set setWebviewController(InAppWebViewController value) {
    _webviewController = value;
    notifyListeners();
  }

  set setShowPreview(bool value) {
    _showPreview = value;
    notifyListeners();
  }

  set setShowProjectPreview(bool value) {
    _showProjectPreview = value;
    notifyListeners();
  }

  set setShowConsole(bool value) {
    _showConsole = value;
    notifyListeners();
  }

  set setEditorText(String value) {
    _editorText = value;
    notifyListeners();
  }

  set setHint(String hint) {
    _hint = hint;
    notifyListeners();
  }

  set setPanelType(PanelType panelType) {
    _panelType = panelType;
    notifyListeners();
  }

  set setCompletedChallenge(bool completed) {
    _completedChallenge = completed;
    notifyListeners();
  }

  set setChallenge(Future<Challenge> challenge) {
    _challenge = challenge;
    notifyListeners();
  }

  set setBlock(Block block) {
    _block = block;
    notifyListeners();
  }

  set setChallengesCompleted(int value) {
    _challengesCompleted = value;
    notifyListeners();
  }

  set setCurrFileType(Syntax value) {
    _currFileType = value;
    notifyListeners();
  }

  set setMounted(bool value) {
    _mounted = value;
    notifyListeners();
  }

  set setConsoleMessages(List<ConsoleMessage> messages) {
    _consoleMessages = messages;
    notifyListeners();
  }

  set setUserConsoleMessages(List<ConsoleMessage> messages) {
    _userConsoleMessages = messages;
    notifyListeners();
  }

  void init(
    String url,
    Block block,
    String challengeId,
    int challengesCompleted,
  ) async {
    setupDialogUi();

    List<int> nonEditorTypes = [10, 11, 15, 19, 21, 22];

    setChallenge = learnOfflineService.getChallenge(url, challengeId);
    Challenge challenge = await _challenge!;

    learnService.setLastVisitedChallenge(url, block);
    if (!nonEditorTypes.contains(challenge.challengeType)) {
      List<ChallengeFile> currentEditedChallenge = challenge.files
          .where((element) => element.editableRegionBoundaries.isNotEmpty)
          .toList();

      if (editorText == null) {
        String text = await fileService.getExactFileFromCache(
          challenge,
          currentEditedChallenge.isEmpty
              ? challenge.files.first
              : currentEditedChallenge.first,
        );

        if (text != '') {
          setEditorText = text;
        }
      }
      setCurrentSelectedFile = currentEditedChallenge.isEmpty
          ? challenge.files[0].name
          : currentEditedChallenge[0].name;
    }

    setBlock = block;
    setChallengesCompleted = challengesCompleted;
  }

  void initiateFile(
    Editor editor,
    Challenge challenge,
    ChallengeFile currFile,
    bool hasRegion,
  ) async {
    if (!_mounted) {
      await Future.delayed(Duration.zero);
      editor.fileTextStream.sink.add(
        FileIDE(
          id: challenge.id + currFile.name,
          ext: currFile.ext.name,
          name: currFile.name,
          content: editorText ?? currFile.contents,
          hasRegion: hasRegion,
          region: EditorRegionOptions(
            start: hasRegion ? currFile.editableRegionBoundaries[0] : null,
            end: hasRegion ? currFile.editableRegionBoundaries[1] : null,
            condition: completedChallenge,
          ),
        ),
      );
      _mounted = true;
    }
  }

  // This prevents the user from requesting the challenge more than once
  // when swichting between preview and the challenge.

  Future<Challenge> initChallenge(String url) async {
    // NOTE: Function is not used anywhere
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response res = await _dio.get(url);

    if (prefs.getString(url) == null) {
      if (res.statusCode == 200) {
        Challenge challenge = Challenge.fromJson(res.data);

        prefs.setString(url, res.data);

        return challenge;
      }
    }

    Challenge challenge = Challenge.fromJson(
      jsonDecode(prefs.getString(url) as String),
    );

    return challenge;
  }

  // This parses the preview document with the correct viewport size. This document
  // is then displayed in the preview panel. The preview document does not modify
  // the original challenge document.

  Future<String> parsePreviewDocument(String doc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Challenge? currChallenge = await challenge;

    if (currChallenge == null) return parse(doc).outerHtml;

    List<ChallengeFile> cssFiles = currChallenge.files
        .where((ChallengeFile file) => file.ext == Ext.css)
        .toList();

    dom.Document document = parse(doc);

    List<ChallengeFile> currentFile = currChallenge.files
        .where((element) => element.ext == Ext.html)
        .toList();

    if (cssFiles.isNotEmpty) {
      String text = prefs.getString(
            '${currChallenge.id}.${currentFile[0].name}',
          ) ??
          currentFile[0].contents;

      document = parse(
        await fileService.parseCssDocmentsAsStyleTags(
          currChallenge,
          text,
        ),
      );
    }

    String viewPort = '''<meta content="width=device-width,
         initial-scale=1.0, maximum-scale=1.0,
         user-scalable=no" name="viewport">
         <meta>''';

    dom.Document viewPortParsed = parse(viewPort);
    dom.Node meta = viewPortParsed.getElementsByTagName('META')[0];

    document.getElementsByTagName('HEAD')[0].append(meta);

    return document.outerHtml;
  }

  Future providePreview(Challenge challenge) async {
    String cacheString = await fileService.getFirstFileFromCache(
      challenge,
      Ext.html,
    );

    Future document = parsePreviewDocument(cacheString);

    return document;
  }

  String parseUsersConsoleMessages(String string) {
    if (!string.startsWith('testMSG')) {
      return '<p>$string</p>';
    }

    return string;
  }

  void refresh() {
    setChallenge = challenge!;
    notifyListeners();
  }

  ChallengeFile currentFile(Challenge challenge) {
    if (currentSelectedFile.isNotEmpty) {
      ChallengeFile file = challenge.files.firstWhere(
        (file) => file.name == currentSelectedFile,
      );
      return file;
    }

    return challenge.files[0];
  }

  void resetCode(Editor editor, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DialogResponse? res = await _dialogService.showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.buttonForm,
      title: context.t.reset_code,
      description: context.t.reset_description,
      mainButtonTitle: context.t.reset,
    );

    if (res?.confirmed == true) {
      Challenge? currChallenge = await challenge;

      for (ChallengeFile file in currChallenge!.files) {
        prefs.remove('${currChallenge.id}.${file.name}');
        prefs.remove('${currChallenge.id}${file.name}');
      }

      var challengeIndex = block!.challengeTiles.indexWhere(
        (element) => element.id == currChallenge.id,
      );

      String slug = block!.challengeTiles[challengeIndex].id;
      String url = LearnService.baseUrl;
      String challengeUrl =
          '$url/challenges/${block!.superBlock.dashedName}/${block!.dashedName}/$slug.json';

      await prefs.remove(challengeUrl);

      _navigationService.replaceWith(
        Routes.challengeView,
        arguments: ChallengeViewArguments(
          url: challengeUrl,
          block: block!,
          challengeId: currChallenge.id,
          challengesCompleted: challengesCompleted,
          isProject: block!.challenges.length == 1,
        ),
      );
    }
  }

  void handleConsoleLogMessagges(ConsoleMessage console, Challenge challenge) {
    // Create a new console log message that adds html tags to the console message

    ConsoleMessage newMessage = ConsoleMessage(
      message: parseUsersConsoleMessages(console.message),
      messageLevel: ConsoleMessageLevel.LOG,
    );

    String msg = console.message;

    // We want to know if it is the first test because when the eval function is called
    // it will run the first test and logs everything to the console. This means that
    // we don't want to add the console messages more than once. So we ignore anything
    // that comes after the first test.

    bool testRelated = msg.startsWith('testMSG: ') || msg.startsWith('index: ');

    if (msg.startsWith('first test done')) {
      setAfterFirstTest = true;
    }

    if (!testRelated && !afterFirstTest) {
      setUserConsoleMessages = [
        ...userConsoleMessages,
        newMessage,
      ];
    }

    // When the message starts with testMSG it indactes that the user has done something
    // that has triggered a test to throw an error. We want to show the error to the user.

    if (msg.startsWith('testMSG: ')) {
      setPanelType = PanelType.hint;
      setHint = msg.split('testMSG: ')[1];
      setShowPanel = true;

      setConsoleMessages = [newMessage, ...userConsoleMessages];
    }

    if (msg == 'completed') {
      setConsoleMessages = [
        ...userConsoleMessages,
        ...consoleMessages,
      ];

      setPanelType = PanelType.pass;
      setCompletedChallenge = true;
      setShowPanel = true;
    }

    setIsRunningTests = false;
  }
}
