import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BlockViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();

  FccUserModel? user;

  bool _isDev = false;
  bool get isDev => _isDev;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  bool _isDownloaded = false;
  bool get isDownloaded => _isDownloaded;

  final bool _isDownloadingSpecific = false;
  bool get isDownloadingSpecific => _isDownloadingSpecific;

  int _challengesCompleted = 0;
  int get challengesCompleted => _challengesCompleted;

  final learnOfflineService = locator<LearnOfflineService>();

  final developerService = locator<DeveloperService>();

  final learnService = locator<LearnService>();

  set setIsOpen(bool widgetIsOpened) {
    _isOpen = widgetIsOpened;
    notifyListeners();
  }

  set setIsDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  set setIsDownloaded(bool value) {
    _isDownloaded = value;
    notifyListeners();
  }

  set setIsDev(bool value) {
    _isDev = value;
    notifyListeners();
  }

  void initBlockState(String blockName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(blockName)) {
      prefs.setBool(blockName, true);
    }

    setBlockOpenState(blockName, prefs.getBool(blockName) ?? false);
  }

  void setBlockOpenState(String blockName, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(blockName, !value);
    _isOpen = !value;
    notifyListeners();
  }

  void routeToChallengeView(Block block, String challengeId) {
    _navigationService.navigateTo(
      Routes.challengeTemplateView,
      arguments: ChallengeTemplateViewArguments(
        challengeId: challengeId,
        block: block,
        challengesCompleted: _challengesCompleted,
      ),
    );
  }

  Future<void> routeToCertification(Block block) async {
    String challengeId = block.challengeTiles[0].id;

    routeToChallengeView(
      block,
      challengeId,
    );
  }

  void init(List<ChallengeListTile> challengeBatch) async {
    user = await _auth.userModel;
    setNumberOfCompletedChallenges(challengeBatch);
    notifyListeners();

    learnOfflineService.downloadSub =
        learnOfflineService.downloadStream.stream.listen(
      (event) {
        if (event == 100.00) {
          setIsDownloading = false;
          learnOfflineService.downloadStream.sink.add(0);
        } else {
          notifyListeners();
        }
      },
      onDone: () {
        setIsDownloading = false;
      },
    );
  }

  void testChallenge(Challenge challenge) {
    learnOfflineService.storeDownloadedChallenge(challenge);
  }

  void setNumberOfCompletedChallenges(List<ChallengeListTile> challengeBatch) {
    int count = 0;
    if (user != null) {
      Iterable<String> completedChallengeIds = user!.completedChallenges.map(
        (e) => e.id,
      );

      for (ChallengeListTile challenge in challengeBatch) {
        if (completedChallengeIds.contains(challenge.id)) {
          count++;
        }
      }
      _challengesCompleted = count;
      notifyListeners();
    }
  }

  bool completedChallenge(String incomingId) {
    if (user != null) {
      for (CompletedChallenge challenge in user!.completedChallenges) {
        if (challenge.id == incomingId) {
          return true;
        }
      }
    }

    return false;
  }

  Icon getIcon(bool completed) {
    if (completed) {
      return const Icon(Icons.check_circle);
    }
    return const Icon(Icons.circle_outlined);
  }

  void stopDownload(Block block, bool isAlreadyDownloaded) async {
    try {
      if (!isAlreadyDownloaded) {
        learnOfflineService.downloadSub!.pause();
        learnOfflineService.batchSub!.pause();
        learnOfflineService.timer!.cancel();

        setIsDownloading = false;
      }

      learnOfflineService.cancelChallengeDownload(block.dashedName).then(
        (value) async {
          setIsDownloaded = await isBlockDownloaded(
            block,
          );
        },
      );

      notifyListeners();
    } catch (e) {
      throw error(e);
    }
  }

  Future<void> startDownload(Block block) async {
    String url = LearnService.baseUrl;
    learnOfflineService
        .getChallengeBatch(
      block,
      block.challengeTiles
          .map((e) =>
              '$url/challenges/${block.superBlock.dashedName}/${block.dashedName}/${e.id}.json')
          .toList(),
    )
        .then((value) async {
      setIsDownloaded = true;
    });
    setIsDownloading = await isBlockDownloaded(
      block,
    );
  }

  Future<bool> isBlockDownloaded(Block incBlock) async {
    List<Block>? blocks = await learnOfflineService.getCachedBlocks(
      incBlock.superBlock.dashedName,
    );

    if (blocks != null) {
      for (Block block in blocks) {
        if (block.dashedName == incBlock.dashedName) {
          return true;
        }
      }
    }

    return false;
  }

  Future<bool> isChallengeDownloaded(String id) async {
    List<ChallengeDownload?> downloaded =
        await learnOfflineService.checkStoredChallenges();
    List<String> ids = downloaded.map((e) => e!.id).toList();

    return ids.contains(id);
  }
}
