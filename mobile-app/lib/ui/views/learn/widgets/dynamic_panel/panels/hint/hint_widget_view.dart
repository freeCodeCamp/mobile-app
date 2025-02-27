import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/hint/hint_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

const forumLocation = 'https://forum.freecodecamp.org';

Future<String> filesToMarkdown(
  Challenge challenge,
  String editorText,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final challengeFiles = challenge.files;
  final bool moreThanOneFile = challengeFiles.length > 1;
  String markdownStr = '\n';

  for (var challengeFile in challengeFiles) {
    final fileName = moreThanOneFile
        ? '/* file: ${challengeFile.name}.${challengeFile.ext} */\n'
        : '';
    final fileType = challengeFile.ext.name;
    final fileContent =
        prefs.getString('${challenge.id}.${challengeFile.name}') ??
            challengeFile.contents;
    markdownStr += '```$fileType\n$fileName$fileContent\n```\n\n';
  }

  return markdownStr;
}

Future<String> getDeviceInfo(BuildContext context) async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return '${deviceInfo.model} - Android ${deviceInfo.version.release} - Android SDK ${deviceInfo.version.sdkInt}';
  } else if (Platform.isIOS) {
    final deviceInfo = await deviceInfoPlugin.iosInfo;
    return '${deviceInfo.model} - ${deviceInfo.systemName}${deviceInfo.systemVersion}';
  } else {
    return context.t.unrecognized_device;
  }
}

Future<String> genForumLink(
  Challenge challenge,
  Block block,
  BuildContext context, {
  String editorText = '',
}) async {
  Challenge? currChallenge = challenge;
  String helpCategoryPath = 'assets/learn/help-category.json';
  String helpCategoryFile = await rootBundle.loadString(helpCategoryPath);

  final String helpCategory = Uri.encodeComponent(
    jsonDecode(helpCategoryFile)[currChallenge.block] ?? 'Help',
  );
  final String blockTitle = block.name;

  final userDeviceInfo = await getDeviceInfo(context);

  final titleText = '$blockTitle - ${currChallenge.title}';
  final String endingText =
      '**Your mobile information:**\n```txt\n$userDeviceInfo\n```\n\n**Challenge:** $titleText\n\n**Link to the challenge:**\nhttps://www.freecodecamp.org/learn/${currChallenge.superBlock}/${currChallenge.block}/${currChallenge.dashedName}';

  final String userCode = await filesToMarkdown(currChallenge, editorText);

  final String textMessage =
      "**Tell us what's happening:**\nDescribe your issue in detail here.\n\n**Your code so far**$userCode\n\n$endingText";
  final String altTextMessage =
      "**Tell us what's happening:**\n\n\n\n**Your code so far**\n\nWARNING\n\nThe challenge seed code and/or your solution exceeded the maximum length we can port over from the challenge.\n\nYou will need to take an additional step here so the code you wrote presents in an easy to read format.\n\nPlease copy/paste all the editor code showing in the challenge from where you just linked.\n\n```\nReplace these two sentences with your copied code.\nPlease leave the ``` line above and the ``` line below,\nbecause they allow your code to properly format in the post.\n\n```\n$endingText";

  String studentCode = Uri.encodeComponent(textMessage);
  String altStudentCode = Uri.encodeComponent(altTextMessage);

  final String baseURL =
      '$forumLocation/new-topic?category=$helpCategory&title=$titleText&body=';
  final String defaultURL = '$baseURL$studentCode';
  final String altURL = '$baseURL$altStudentCode';

  return defaultURL.length < 8000 ? defaultURL : altURL;
}

class HintWidgetView extends StatelessWidget {
  const HintWidgetView(
      {Key? key,
      required this.hint,
      required this.challengeModel,
      required this.editor})
      : super(key: key);

  final String hint;
  final ChallengeViewModel challengeModel;

  final Editor editor;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<HintWidgetModel>.reactive(
      viewModelBuilder: () => HintWidgetModel(),
      builder: (context, model, child) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.t.hint,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: Colors.white.withValues(alpha: 0.87),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        challengeModel.setShowPanel = false;
                      },
                      icon: const Icon(Icons.clear_sharp),
                      iconSize: 40,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: parser.parse(hint),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final forumLink = await genForumLink(
                            challengeModel.challenge as Challenge,
                            challengeModel.block as Block,
                            context,
                            editorText: challengeModel.editorText ?? '');
                        challengeModel.learnService.forumHelpDialog(forumLink);
                      },
                      icon: const Icon(Icons.question_mark),
                      padding: const EdgeInsets.all(16),
                    ),
                    IconButton(
                      onPressed: () {
                        challengeModel.resetCode(editor, context);
                      },
                      icon: const Icon(Icons.restart_alt),
                      padding: const EdgeInsets.all(16),
                    ),
                    IconButton(
                      onPressed: () {
                        challengeModel.setShowPreview = true;
                        challengeModel.setShowPanel = false;
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      padding: const EdgeInsets.all(16),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
