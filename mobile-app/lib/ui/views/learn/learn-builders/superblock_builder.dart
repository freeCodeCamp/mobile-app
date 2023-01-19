import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/block-builder/block_builder_view.dart';
import 'package:freecodecamp/ui/views/learn/learn/learn_model.dart';
import 'package:stacked/stacked.dart';

class SuperBlockView extends StatelessWidget {
  SuperBlockView({
    Key? key,
    required this.superBlockDashedName,
    required this.superBlockName,
    required this.hasInternet,
  }) : super(key: key);

  final String superBlockDashedName;
  final String superBlockName;
  final bool hasInternet;

  final learnOfflineService = locator<LearnOfflineService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
      viewModelBuilder: () => LearnViewModel(),
      onViewModelReady: (model) => AuthenticationService.staticIsloggedIn
          ? model.auth.fetchUser()
          : null,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(superBlockName),
        ),
        body: FutureBuilder<SuperBlock>(
          future: model.getSuperBlockData(
            superBlockDashedName,
            superBlockName,
            hasInternet,
          ),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data is SuperBlock) {
                SuperBlock superBlock = snapshot.data as SuperBlock;

                if (superBlock.blocks == null || superBlock.blocks!.isEmpty) {
                  return const Text('You are offline, and no downloads!');
                }
                return superBlockTemplate(model, superBlock);
              }
            }

            if (snapshot.hasError) {
              return const Text('Something whent wrong, please refresh!');
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
    );
  }

  Widget superBlockTemplate(LearnViewModel model, SuperBlock superBlock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView.separated(
          separatorBuilder: (context, int i) => Divider(
            height: superBlock.blocks![i].challenges.length == 1
                ? 50
                : superBlock.blocks![i].isStepBased
                    ? 3
                    : superBlock.blocks![i].dashedName == 'es6'
                        ? 0
                        : 50,
            color: const Color.fromRGBO(0, 0, 0, 0),
          ),
          shrinkWrap: true,
          itemCount: superBlock.blocks!.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, i) => Padding(
            padding: i == 0
                ? const EdgeInsets.only(top: 16)
                : i == superBlock.blocks!.length - 1
                    ? const EdgeInsets.only(bottom: 16)
                    : EdgeInsets.zero,
            child: BlockBuilderView(
              key: ObjectKey(superBlock.blocks![i].dashedName),
              block: superBlock.blocks![i],
            ),
          ),
        ),
      ),
    );
  }
}
