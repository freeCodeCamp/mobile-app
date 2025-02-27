import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/utils/learn_globals.dart';
import 'package:freecodecamp/ui/views/learn/widgets/download_button_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/open_close_icon_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/progressbar_widget.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class BlockView extends StatelessWidget {
  final Block block;
  final bool isOpen;
  final bool isStepBased;

  const BlockView({
    Key? key,
    required this.block,
    required this.isOpen,
    required this.isStepBased,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockViewModel>.reactive(
      onViewModelReady: (model) async {
        model.init(block.challengeTiles);
        model.setIsOpen = isOpen;
        model.setIsDownloaded = await model.isBlockDownloaded(block);
        model.setIsDev = await model.developerService.developmentMode();
      },
      viewModelBuilder: () => BlockViewModel(),
      builder: (
        context,
        model,
        child,
      ) {
        bool isCert = block.challenges.length == 1 &&
            !hasNoCert.contains(block.superBlock.dashedName);
        bool isDialogue = hasDialogue.contains(block.superBlock.dashedName);
        int calculateProgress =
            (model.challengesCompleted / block.challenges.length * 100).round();

        bool hasProgress = calculateProgress > 0;

        return Column(
          children: [
            BlockHeader(
              isCertification: isCert,
              block: block,
              model: model,
            ),
            if (hasProgress && isStepBased)
              ChallengeProgressBar(
                block: block,
                model: model,
              ),
            if (model.isOpen || isCert)
              Container(
                color: const Color(0xFF0a0a23),
                child: InkWell(
                  onTap: isCert
                      ? () async {
                          model.routeToCertification(block);
                        }
                      : () {},
                  child: Column(
                    children: [
                      for (String blockString in block.description)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Text(
                            blockString,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              fontFamily: 'Lato',
                              color: Colors.white.withValues(alpha: 0.87),
                            ),
                          ),
                        ),
                      if (model.isDev && !isCert)
                        DownloadButton(
                          model: model,
                          block: block,
                        ),
                      if (isDialogue) ...[
                        buildDivider(),
                        dialogueWidget(
                          block.challenges,
                          context,
                          model,
                        )
                      ],
                      if (!isCert && isStepBased && !isDialogue) ...[
                        buildDivider(),
                        gridWidget(context, model)
                      ],
                      if (!isStepBased && !isCert) ...[
                        buildDivider(),
                        listWidget(context, model)
                      ],
                      Container(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget dialogueWidget(
    List<ChallengeOrder> challenges,
    BuildContext context,
    BlockViewModel model,
  ) {
    List<List<ChallengeOrder>> structure = [];

    List<ChallengeOrder> dialogueHeaders = [];
    int dialogueIndex = 0;

    dialogueHeaders.add(challenges[0]);
    structure.add([]);

    for (int i = 1; i < challenges.length; i++) {
      if (challenges[i].title.contains('Dialogue')) {
        structure.add([]);
        dialogueHeaders.add(challenges[i]);
        dialogueIndex++;
      } else {
        structure[dialogueIndex].add(challenges[i]);
      }
    }
    return Column(
      children: [
        ...List.generate(structure.length, (step) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  dialogueHeaders[step].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                crossAxisCount: (MediaQuery.of(context).size.width / 70 -
                        MediaQuery.of(context).viewPadding.horizontal)
                    .round(),
                children: List.generate(
                  structure[step].length,
                  (index) {
                    return Center(
                      child: ChallengeTile(
                        block: block,
                        model: model,
                        challengeId: structure[step][index].id,
                        step: int.parse(
                          structure[step][index].title.split('Task')[1],
                        ),
                        isDowloaded: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        })
      ],
    );
  }

  Widget gridWidget(BuildContext context, BlockViewModel model) {
    return SizedBox(
      height: 300,
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: (MediaQuery.of(context).size.width / 70 -
                MediaQuery.of(context).viewPadding.horizontal)
            .round(),
        children: List.generate(
          block.challenges.length,
          (step) {
            return FutureBuilder(
              future: model.isChallengeDownloaded(
                block.challengeTiles[step].id,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: ChallengeTile(
                      block: block,
                      model: model,
                      step: step + 1,
                      challengeId: block.challengeTiles[step].id,
                      isDowloaded: (snapshot.data is bool
                          ? snapshot.data as bool
                          : false),
                    ),
                  );
                }

                return const CircularProgressIndicator();
              },
            );
          },
        ),
      ),
    );
  }

  Widget listWidget(BuildContext context, BlockViewModel model) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: block.challenges.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, i) => ListTile(
            leading: model.getIcon(
              model.completedChallenge(
                block.challengeTiles[i].id,
              ),
            ),
            title: Text(block.challengeTiles[i].name),
            onTap: () async {
              String challengeId = block.challengeTiles[i].id;

              model.routeToChallengeView(
                block,
                challengeId,
              );
            },
          ),
        ),
      ],
    );
  }
}

class BlockHeader extends StatelessWidget {
  const BlockHeader({
    Key? key,
    required this.isCertification,
    required this.block,
    required this.model,
  }) : super(key: key);

  final bool isCertification;
  final BlockViewModel model;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0a0a23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCertification)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 8, left: 8),
              color: const Color.fromRGBO(0x00, 0x2e, 0xad, 1),
              child: Text(
                context.t.certification_project,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0x19, 0x8e, 0xee, 1),
                ),
              ),
            ),
          ListTile(
            onTap: () {
              model.setBlockOpenState(
                block.name,
                model.isOpen,
              );
            },
            minVerticalPadding: 24,
            trailing: !isCertification
                ? OpenCloseIcon(
                    block: block,
                    model: model,
                  )
                : null,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isCertification)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: model.challengesCompleted == block.challenges.length
                        ? const Icon(
                            Icons.check_circle,
                            size: 20,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            size: 20,
                          ),
                  ),
                Expanded(
                  child: Text(
                    block.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    Key? key,
    required this.block,
    required this.model,
    required this.step,
    required this.isDowloaded,
    required this.challengeId,
  }) : super(key: key);

  final Block block;
  final BlockViewModel model;
  final int step;
  final bool isDowloaded;
  final String challengeId;

  @override
  Widget build(BuildContext context) {
    bool isCompleted = model.completedChallenge(challengeId);

    return GridTile(
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDowloaded && model.isDownloading && isCompleted
                ? Colors.green
                : Colors.white.withValues(alpha: 0.01),
            width: isDowloaded && model.isDownloading && isCompleted ? 5 : 1,
          ),
          color: isCompleted
              ? const Color.fromRGBO(0x00, 0x2e, 0xad, 1)
              : isDowloaded && model.isDownloading && !isCompleted
                  ? Colors.green
                  : Colors.transparent,
        ),
        height: 70,
        width: 70,
        child: InkWell(
          onTap: () async {
            model.routeToChallengeView(
              block,
              challengeId,
            );
          },
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
