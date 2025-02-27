import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnService {
  static final LearnService _learnService = LearnService._internal();
  final _authenticationService = locator<AuthenticationService>();

  final Dio _dio = DioService.dio;

  static final baseUrl = '${AuthenticationService.baseURL}/curriculum-data/v1';

  final LearnOfflineService learnOfflineService =
      locator<LearnOfflineService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  factory LearnService() {
    return _learnService;
  }

  void setLastVisitedChallenge(String url, Block block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('lastVisitedChallenge', [
      url,
      block.superBlock.dashedName,
      block.superBlock.name,
      block.dashedName,
    ]);
  }

  Future<void> postChallengeCompleted(
    Challenge challenge, {
    List? challengeFiles,
    String? solutionLink,
  }) async {
    String challengeId = challenge.id;
    int challengeType = challenge.challengeType;

    Response submitTypesRes = await _dio.get(
        '${AuthenticationService.baseURL}/curriculum-data/submit-types.json');
    Map<String, dynamic> submitTypes = submitTypesRes.data;

    switch (submitTypes[challengeType.toString()]) {
      case 'tests':
        late Map payload;
        if (challengeType == 14 ||
            challenge.block ==
                'javascript-algorithms-and-data-structures-projects') {
          payload = {
            'id': challengeId,
            'challengeType': challengeType,
            'files': challengeFiles,
          };
        } else {
          payload = {
            'id': challengeId,
            'challengeType': challengeType,
          };
        }
        Response res = await _dio.post(
          '${AuthenticationService.baseApiURL}/modern-challenge-completed',
          data: payload,
          options: Options(
            headers: {
              'CSRF-Token': _authenticationService.csrfToken,
              'Cookie':
                  'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
            },
          ),
        );
        log(res.toString());
        break;
      case 'backend':
        break;
      case 'project.backEnd':
        Map payload = {
          'id': challengeId,
          'challengeType': challengeType,
          'solution': solutionLink
        };
        Response res = await _dio.post(
          '${AuthenticationService.baseApiURL}/project-completed',
          data: payload,
          options: Options(
            headers: {
              'CSRF-Token': _authenticationService.csrfToken,
              'Cookie':
                  'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
            },
          ),
        );
        log(res.toString());
        break;
      case 'project.frontEnd':
        break;
    }
    await _authenticationService.fetchUser();
  }

  void updateProgressOnPop(BuildContext context, Block block) async {
    learnOfflineService.hasInternet().then(
          (value) => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (
                context,
                animation1,
                animation2,
              ) =>
                  SuperBlockView(
                superBlockDashedName: block.superBlock.dashedName,
                superBlockName: block.superBlock.name,
                hasInternet: value,
              ),
            ),
          ),
        );
  }

  void passChallenge(
    Challenge challenge,
    String? solutionLink,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List challengeFiles = challenge.files.map((file) {
      return {
        'contents':
            prefs.getString('${challenge.id}.${file.name}') ?? file.contents,
        'ext': file.ext.name,
        'history': file.history,
        'key': file.fileKey,
        'name': file.name,
      };
    }).toList();

    await postChallengeCompleted(
      challenge,
      challengeFiles: challengeFiles,
      solutionLink: solutionLink,
    );
  }

  void goToNextChallenge(
    int maxChallenges,
    int challengesCompleted,
    Challenge challenge,
    Block block, {
    String solutionLink = '',
  }) async {
    if (AuthenticationService.staticIsloggedIn) {
      passChallenge(challenge, solutionLink);
    }
    var challengeIndex = block.challengeTiles.indexWhere(
      (element) => element.id == challenge.id,
    );
    if (challengeIndex == maxChallenges - 1) {
      _navigationService.back();
    } else {
      _navigationService.replaceWith(
        Routes.challengeTemplateView,
        arguments: ChallengeTemplateViewArguments(
          challengeId: block.challengeTiles[challengeIndex + 1].id,
          block: block,
          challengesCompleted: challengesCompleted + 1,
        ),
      );
    }
  }

  Future forumHelpDialog(String url) async {
    DialogResponse? res = await _dialogService.showCustomDialog(
        barrierDismissible: true,
        variant: DialogType.buttonForm,
        title: 'Ask for Help',
        description:
            "If you've already tried the Read-Search-Ask method, then you can try asking for help on the freeCodeCamp forum.",
        mainButtonTitle: 'Create a post');
    if (res != null && res.confirmed) {
      launchUrl(Uri.parse(url));
    }
  }

  LearnService._internal();
}
