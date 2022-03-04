import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/block-builder/block_builder_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_view.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class BlockBuilderView extends StatelessWidget {
  const BlockBuilderView({
    Key? key,
    required this.block,
  }) : super(key: key);

  final Block block;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockBuilderModel>.reactive(
        viewModelBuilder: () => BlockBuilderModel(),
        builder: (context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xFF0a0a23),
                        padding: const EdgeInsets.all(24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            block.blockName,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 4),
                        child: ListTile(
                          tileColor: const Color(0xFF0a0a23),
                          leading: Icon(model.isOpen
                              ? Icons.arrow_drop_down_sharp
                              : Icons.arrow_right_sharp),
                          title: Text(model.isOpen
                              ? 'collapse course'
                              : 'expand course'),
                          trailing: Text(
                            '0/${block.challenges.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            model.setIsOpen = !model.isOpen;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: model.isOpen
                                ? ChallengeBuilderView(
                                    block: block,
                                  )
                                : Container(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ));
  }
}
