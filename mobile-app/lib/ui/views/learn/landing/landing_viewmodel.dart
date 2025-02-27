import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LearnLandingViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final AuthenticationService _auth = locator<AuthenticationService>();
  AuthenticationService get auth => _auth;

  final LearnService _learnService = locator<LearnService>();
  LearnService get learnService => _learnService;

  final SnackbarService _snack = locator<SnackbarService>();
  SnackbarService get snack => _snack;

  final _learnOfflineService = locator<LearnOfflineService>();
  LearnOfflineService get learnOfflineService => _learnOfflineService;

  Future<List<SuperBlockButtonData>>? superBlockButtons;
  final _dio = DioService.dio;

  bool _hasLastVisitedChallenge = false;
  bool get hasLastVisitedChallenge => _hasLastVisitedChallenge;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set setSuperBlockButtons(value) {
    superBlockButtons = value;
    notifyListeners();
  }

  set setHasLastVisitedChallenge(value) {
    _hasLastVisitedChallenge = value;
    notifyListeners();
  }

  void init(BuildContext context) async {
    setupDialogUi();
    retrieveNewQuote();
    initLoggedInListener();

    setSuperBlockButtons = getSuperBlocks();

    retrieveLastVisitedChallenge();
  }

  void retrieveLastVisitedChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setHasLastVisitedChallenge =
        prefs.getStringList('lastVisitedChallenge')?.isNotEmpty ?? false;
    notifyListeners();
  }

  void fastRouteToChallenge() async {
    FccUserModel? user;

    int completedChallenges = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? lastVisitedChallenge = prefs.getStringList(
      'lastVisitedChallenge',
    );

    // Values
    // 0: full challenge url
    // 1: superblock dashed name
    // 2: superblock name
    // 3: block dashed name

    if (lastVisitedChallenge != null) {
      Challenge challenge = await learnOfflineService.getChallenge(
        lastVisitedChallenge[0],
      );

      String baseUrl = LearnService.baseUrl;

      final Response res =
          await _dio.get('$baseUrl/${lastVisitedChallenge[1]}.json');

      if (res.statusCode == 200) {
        List<Block> blocks = SuperBlock.fromJson(
          res.data,
          lastVisitedChallenge[1],
          lastVisitedChallenge[2],
        ).blocks as List<Block>;

        if (AuthenticationService.staticIsloggedIn) {
          user = await auth.userModel;
        }

        Block block = blocks.firstWhere(
          (element) => element.dashedName == lastVisitedChallenge[3],
        );

        Iterable<String> completedChallengeIds = user!.completedChallenges.map(
          (e) => e.id,
        );

        for (int i = 0; i < block.challenges.length; i++) {
          if (completedChallengeIds.contains(block.challenges[i].id)) {
            completedChallenges++;
          }
        }

        _navigationService.navigateToSuperBlockView(
          superBlockDashedName: lastVisitedChallenge[1],
          superBlockName: lastVisitedChallenge[2],
          hasInternet: true,
        );

        _navigationService.navigateToChallengeTemplateView(
          block: block,
          challengesCompleted: completedChallenges,
          challengeId: challenge.id,
        );
      }
    }
  }

  Future<List<SuperBlockButtonData>> getSuperBlocks() async {
    return await _learnOfflineService.hasInternet()
        ? requestSuperBlocks()
        : _learnOfflineService.getCachedSuperblocks();
  }

  void refresh() async {
    setSuperBlockButtons = getSuperBlocks();

    notifyListeners();
  }

  void initLoggedInListener() {
    _isLoggedIn = AuthenticationService.staticIsloggedIn;
    notifyListeners();
    auth.isLoggedIn.listen((e) {
      _isLoggedIn = e;
      notifyListeners();
    });
  }

  void disabledButtonSnack() {
    snack.showSnackbar(title: 'Not available use the web version', message: '');
    Future.delayed(const Duration(milliseconds: 2500), () {
      snack.closeSnackbar();
    });
  }

  Future<List<SuperBlockButtonData>> requestSuperBlocks() async {
    String baseUrl = LearnService.baseUrl;

    final Response res = await _dio.get('$baseUrl/available-superblocks.json');

    List<SuperBlockButtonData> buttonData = [];

    if (res.statusCode == 200) {
      List superBlocks = res.data['superblocks'];

      await dotenv.load(fileName: '.env');

      bool showAllSB =
          dotenv.get('SHOWALLSB', fallback: 'false').toLowerCase() == 'true';

      for (int i = 0; i < superBlocks.length; i++) {
        buttonData.add(
          SuperBlockButtonData(
            path: superBlocks[i]['dashedName'],
            name: superBlocks[i]['title'],
            public: !showAllSB ? superBlocks[i]['public'] : true,
          ),
        );
      }

      return buttonData;
    }
    return [];
  }

  void routeToSuperBlock(String dashedName, String name) async {
    _navigationService.navigateTo(
      Routes.superBlockView,
      arguments: SuperBlockViewArguments(
        superBlockDashedName: dashedName,
        superBlockName: name,
        hasInternet: await learnOfflineService.hasInternet(),
      ),
    );
  }

  void goBack() {
    _navigationService.back();
  }

  Future<MotivationalQuote> retrieveNewQuote() async {
    String path = 'assets/learn/motivational-quotes.json';
    String file = await rootBundle.loadString(path);

    int quoteLength = jsonDecode(file)['motivationalQuotes'].length;

    Random random = Random();

    int randomValue = random.nextInt(quoteLength);

    dynamic json = jsonDecode(file)['motivationalQuotes'][randomValue];

    MotivationalQuote quote = MotivationalQuote.fromJson(json);

    return quote;
  }
}
