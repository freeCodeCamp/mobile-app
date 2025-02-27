import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/dynamic_panel.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:stacked/stacked.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({
    Key? key,
    required this.block,
    required this.challenge,
    required this.challengesCompleted,
    required this.isProject,
  }) : super(key: key);

  final Challenge challenge;
  final Block block;
  final int challengesCompleted;
  final bool isProject;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeViewModel>.reactive(
      viewModelBuilder: () => ChallengeViewModel(),
      onViewModelReady: (model) {
        model.init(block, challenge, challengesCompleted);
      },
      builder: (context, model, child) => Builder(
        builder: (context) {
          int maxChallenges = block.challenges.length;
          ChallengeFile currFile = model.currentFile(challenge);

          bool keyboard = MediaQuery.of(context).viewInsets.bottom != 0;

          bool onlyJs = challenge.files.every((file) => file.ext.name == 'js');

          bool editableRegion = currFile.editableRegionBoundaries.isNotEmpty;
          EditorOptions options = EditorOptions(
            hasRegion: editableRegion,
          );

          Editor editor = Editor(
            language: currFile.ext.name.toUpperCase(),
            options: options,
          );

          model.initiateFile(editor, challenge, currFile, editableRegion);
          model.listenToFocusedController(editor);
          model.listenToSymbolBarScrollController();

          if (model.showPanel) {
            FocusManager.instance.primaryFocus?.unfocus();
          }

          editor.onTextChange.stream.listen((text) {
            model.fileService.saveFileInCache(
              challenge,
              model.currentSelectedFile != ''
                  ? model.currentSelectedFile
                  : challenge.files[0].name,
              text,
            );

            model.setEditorText = text;
            model.setHasTypedInEditor = true;
            model.setCompletedChallenge = false;
          });

          BoxDecoration decoration = const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 4,
                color: Colors.blue,
              ),
            ),
          );

          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, dynamic result) {
              model.learnService.updateProgressOnPop(context, block);
            },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(
                  MediaQuery.sizeOf(context).width,
                  model.showPanel ? 0 : 50,
                ),
                child: AppBar(
                  automaticallyImplyLeading: !model.showPreview,
                  title: challenge.files.length == 1 && !model.showPreview
                      ? Text(context.t.editor)
                      : Row(
                          children: [
                            if (model.showPreview && !onlyJs)
                              Expanded(
                                child: Container(
                                  decoration: model.showProjectPreview
                                      ? decoration
                                      : null,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      model.setShowConsole = false;
                                      model.setShowProjectPreview = true;
                                    },
                                    child: Text(
                                      context.t.preview,
                                    ),
                                  ),
                                ),
                              ),
                            if (model.showPreview)
                              Expanded(
                                child: Container(
                                  decoration:
                                      model.showConsole ? decoration : null,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      model.setShowConsole = true;
                                      model.setShowProjectPreview = false;
                                    },
                                    child: Text(
                                      context.t.console,
                                    ),
                                  ),
                                ),
                              ),
                            if (!model.showPreview &&
                                challenge.files.length > 1)
                              for (ChallengeFile file in challenge.files)
                                customTabBar(
                                  model,
                                  challenge,
                                  file,
                                  editor,
                                )
                          ],
                        ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: customBottomBar(
                  model,
                  keyboard,
                  challenge,
                  editor,
                  context,
                ),
              ),
              body: !model.showPreview
                  ? Column(
                      children: [
                        if (model.showPanel && !keyboard)
                          DynamicPanel(
                            challenge: challenge,
                            model: model,
                            panel: model.panelType,
                            maxChallenges: maxChallenges,
                            challengesCompleted: challengesCompleted,
                            editor: editor,
                          ),
                        Expanded(child: editor)
                      ],
                    )
                  : Column(
                      children: [
                        if (model.showPanel && !keyboard)
                          DynamicPanel(
                            challenge: challenge,
                            model: model,
                            panel: model.panelType,
                            maxChallenges: maxChallenges,
                            challengesCompleted: challengesCompleted,
                            editor: editor,
                          ),
                        model.showProjectPreview && !onlyJs
                            ? ProjectPreview(
                                challenge: challenge,
                                model: model,
                              )
                            : JavaScriptConsole(
                                messages: model.consoleMessages,
                              )
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget customTabBar(
    ChallengeViewModel model,
    Challenge challenge,
    ChallengeFile file,
    Editor editor,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: model.currentFile(challenge).name == file.name
                ? const BorderSide(width: 4, color: Colors.blue)
                : const BorderSide(),
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            model.setCurrentSelectedFile = file.name;
            ChallengeFile currFile = model.currentFile(challenge);

            String currText = await model.fileService.getExactFileFromCache(
              challenge,
              currFile,
            );

            bool hasRegion = currFile.editableRegionBoundaries.isNotEmpty;

            editor.fileTextStream.sink.add(
              FileIDE(
                id: challenge.id + currFile.name,
                ext: currFile.ext.name.toUpperCase(),
                name: currFile.name,
                content: currText == '' ? currFile.contents : currText,
                hasRegion: currFile.editableRegionBoundaries.isNotEmpty,
                region: EditorRegionOptions(
                  start:
                      hasRegion ? currFile.editableRegionBoundaries[0] : null,
                  end: hasRegion ? currFile.editableRegionBoundaries[1] : null,
                ),
              ),
            );

            model.setEditorText = currText == '' ? currFile.contents : currText;
            model.setShowPreview = false;
          },
          child: Text(
            '${file.name}.${file.ext.name}',
            style: TextStyle(
                color: model.currentFile(challenge).name == file.name
                    ? Colors.blue
                    : Colors.white,
                fontWeight: model.currentFile(challenge).name == file.name
                    ? FontWeight.bold
                    : null),
          ),
        ),
      ),
    );
  }

  Widget customBottomBar(
    ChallengeViewModel model,
    bool keyboard,
    Challenge challenge,
    Editor editor,
    BuildContext context,
  ) {
    return BottomAppBar(
      height: keyboard ? 116 : 72,
      padding: keyboard ? const EdgeInsets.only(bottom: 8) : null,
      color: const Color(0xFF0a0a23),
      child: Column(
        children: [
          if (keyboard)
            SymbolBar(
              model: model,
              editor: editor,
            ),
          Row(
            children: [
              SizedBox(
                width: 1,
                height: 1,
                child: InAppWebView(
                  onWebViewCreated: (controller) {
                    model.setTestController = controller;
                  },
                  onConsoleMessage: (controller, console) {
                    model.handleConsoleLogMessagges(console, challenge);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color:
                    model.showPanel && model.panelType == PanelType.instruction
                        ? Colors.white
                        : const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: 32,
                    color: model.showPanel &&
                            model.panelType == PanelType.instruction
                        ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                        : Colors.white,
                  ),
                  onPressed: () {
                    if (model.showPanel &&
                        model.panelType != PanelType.instruction) {
                      model.setPanelType = PanelType.instruction;
                    } else {
                      model.setPanelType = PanelType.instruction;
                      if (MediaQuery.of(context).viewInsets.bottom > 0) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (!model.showPanel) {
                          model.setShowPanel = true;
                        }
                      } else {
                        model.setShowPanel = !model.showPanel;
                      }
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: !model.showPreview
                    ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                    : Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 32,
                    color: model.showPreview
                        ? const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1)
                        : Colors.white,
                  ),
                  onPressed: () async {
                    ChallengeFile currFile = model.currentFile(challenge);

                    String currText =
                        await model.fileService.getExactFileFromCache(
                      challenge,
                      currFile,
                    );

                    model.setMounted = false;

                    editor.fileTextStream.sink.add(FileIDE(
                      id: challenge.id + currFile.name,
                      ext: currFile.ext.name.toUpperCase(),
                      name: currFile.name,
                      content: currText == '' ? currFile.contents : currText,
                      hasRegion: currFile.editableRegionBoundaries.isNotEmpty,
                      region: EditorRegionOptions(
                        start: currFile.editableRegionBoundaries.isNotEmpty
                            ? currFile.editableRegionBoundaries[0]
                            : null,
                        end: currFile.editableRegionBoundaries.isNotEmpty
                            ? currFile.editableRegionBoundaries[1]
                            : null,
                      ),
                    ));
                    model.setEditorText =
                        currText == '' ? currFile.contents : currText;
                    model.setShowPreview = !model.showPreview;

                    if (!model.showProjectPreview && !model.showConsole) {
                      model.setShowProjectPreview = true;
                    }

                    model.refresh();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: !model.hasTypedInEditor
                          ? const Color.fromARGB(255, 9, 79, 125)
                          : model.completedChallenge
                              ? const Color.fromRGBO(0x20, 0xD0, 0x32, 1)
                              : const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                      child: IconButton(
                        icon: model.runningTests
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : model.completedChallenge
                                ? const Icon(Icons.arrow_forward_rounded,
                                    size: 30)
                                : const Icon(Icons.done_rounded, size: 30),
                        onPressed: model.hasTypedInEditor
                            ? () async {
                                model.setAfterFirstTest = false;
                                model.setConsoleMessages = [];
                                model.setUserConsoleMessages = [];
                                if (model.showPanel &&
                                    model.panelType == PanelType.pass) {
                                  model.learnService.goToNextChallenge(
                                    model.block!.challenges.length,
                                    challengesCompleted,
                                    challenge,
                                    block,
                                  );
                                }

                                model.setShowPanel = false;
                                model.setIsRunningTests = true;
                                await model.runner.setWebViewContent(
                                  challenge,
                                  controller: model.testController!,
                                );
                              }
                            : null,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SymbolBar extends StatelessWidget {
  const SymbolBar({
    super.key,
    required this.editor,
    required this.model,
  });

  final Editor editor;
  final ChallengeViewModel model;

  static List<String> symbols = ['<', '/', '>', '\\', '\'', '"', '=', '{', '}'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 50,
      color: const Color(0xFF1b1b32),
      child: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: model.symbolBarScrollController,
            itemCount: symbols.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 1,
                ),
                child: TextButton(
                  onPressed: () {
                    model.insertSymbol(symbols[index], editor);
                  },
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                  ),
                  child: Text(symbols[index]),
                ),
              );
            },
          ),
          if (model.symbolBarIsScrollable)
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 15,
                      height: 66,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.13),
                            Colors.white.withValues(alpha: 0.23),
                            Colors.white.withValues(alpha: 0.33),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ProjectPreview extends StatelessWidget {
  const ProjectPreview({
    Key? key,
    required this.challenge,
    required this.model,
  }) : super(key: key);

  final Challenge challenge;
  final ChallengeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: model.providePreview(challenge),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is String) {
              return InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: snapshot.data as String,
                  mimeType: 'text/html',
                ),
                onWebViewCreated: (controller) {
                  model.setWebviewController = controller;
                },
              );
            }
          }

          if (snapshot.hasError) {
            Center(
              child: Text(context.t.error),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
