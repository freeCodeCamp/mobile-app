// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i18;
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart' as _i22;
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart'
    as _i21;
import 'package:freecodecamp/models/podcasts/episodes_model.dart' as _i19;
import 'package:freecodecamp/models/podcasts/podcasts_model.dart' as _i20;
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart' as _i10;
import 'package:freecodecamp/ui/views/learn/challenge/templates/template_view.dart'
    as _i11;
import 'package:freecodecamp/ui/views/learn/landing/landing_view.dart' as _i13;
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart'
    as _i15;
import 'package:freecodecamp/ui/views/login/native_login_view.dart' as _i14;
import 'package:freecodecamp/ui/views/news/news-author/news_author_view.dart'
    as _i8;
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart'
    as _i6;
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart'
    as _i7;
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_view.dart'
    as _i9;
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart'
    as _i5;
import 'package:freecodecamp/ui/views/news/news-view-handler/news_view_handler_view.dart'
    as _i2;
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart' as _i4;
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart'
    as _i3;
import 'package:freecodecamp/ui/views/profile/profile_view.dart' as _i12;
import 'package:freecodecamp/ui/views/settings/delete-account/delete_account_view.dart'
    as _i17;
import 'package:freecodecamp/ui/views/settings/settings_view.dart' as _i16;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i23;

class Routes {
  static const newsViewHandlerView = '/news-view-handler-view';

  static const podcastListView = '/podcast-list-view';

  static const episodeView = '/episode-view';

  static const newsTutorialView = '/news-tutorial-view';

  static const newsBookmarkTutorialView = '/news-bookmark-tutorial-view';

  static const newsFeedView = '/news-feed-view';

  static const newsAuthorView = '/news-author-view';

  static const newsImageView = '/news-image-view';

  static const codeRadioView = '/code-radio-view';

  static const challengeTemplateView = '/challenge-template-view';

  static const profileView = '/profile-view';

  static const learnLandingView = '/';

  static const nativeLoginView = '/native-login-view';

  static const superBlockView = '/super-block-view';

  static const settingsView = '/settings-view';

  static const deleteAccountView = '/delete-account-view';

  static const all = <String>{
    newsViewHandlerView,
    podcastListView,
    episodeView,
    newsTutorialView,
    newsBookmarkTutorialView,
    newsFeedView,
    newsAuthorView,
    newsImageView,
    codeRadioView,
    challengeTemplateView,
    profileView,
    learnLandingView,
    nativeLoginView,
    superBlockView,
    settingsView,
    deleteAccountView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.newsViewHandlerView,
      page: _i2.NewsViewHandlerView,
    ),
    _i1.RouteDef(
      Routes.podcastListView,
      page: _i3.PodcastListView,
    ),
    _i1.RouteDef(
      Routes.episodeView,
      page: _i4.EpisodeView,
    ),
    _i1.RouteDef(
      Routes.newsTutorialView,
      page: _i5.NewsTutorialView,
    ),
    _i1.RouteDef(
      Routes.newsBookmarkTutorialView,
      page: _i6.NewsBookmarkTutorialView,
    ),
    _i1.RouteDef(
      Routes.newsFeedView,
      page: _i7.NewsFeedView,
    ),
    _i1.RouteDef(
      Routes.newsAuthorView,
      page: _i8.NewsAuthorView,
    ),
    _i1.RouteDef(
      Routes.newsImageView,
      page: _i9.NewsImageView,
    ),
    _i1.RouteDef(
      Routes.codeRadioView,
      page: _i10.CodeRadioView,
    ),
    _i1.RouteDef(
      Routes.challengeTemplateView,
      page: _i11.ChallengeTemplateView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i12.ProfileView,
    ),
    _i1.RouteDef(
      Routes.learnLandingView,
      page: _i13.LearnLandingView,
    ),
    _i1.RouteDef(
      Routes.nativeLoginView,
      page: _i14.NativeLoginView,
    ),
    _i1.RouteDef(
      Routes.superBlockView,
      page: _i15.SuperBlockView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i16.SettingsView,
    ),
    _i1.RouteDef(
      Routes.deleteAccountView,
      page: _i17.DeleteAccountView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.NewsViewHandlerView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.NewsViewHandlerView(),
        settings: data,
      );
    },
    _i3.PodcastListView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.PodcastListView(),
        settings: data,
      );
    },
    _i4.EpisodeView: (data) {
      final args = data.getArgs<EpisodeViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.EpisodeView(
            key: args.key, episode: args.episode, podcast: args.podcast),
        settings: data,
      );
    },
    _i5.NewsTutorialView: (data) {
      final args = data.getArgs<NewsTutorialViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.NewsTutorialView(
            key: args.key, refId: args.refId, title: args.title),
        settings: data,
      );
    },
    _i6.NewsBookmarkTutorialView: (data) {
      final args =
          data.getArgs<NewsBookmarkTutorialViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.NewsBookmarkTutorialView(
            key: args.key, tutorial: args.tutorial),
        settings: data,
      );
    },
    _i7.NewsFeedView: (data) {
      final args = data.getArgs<NewsFeedViewArguments>(
        orElse: () => const NewsFeedViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.NewsFeedView(
            key: args.key,
            tagSlug: args.tagSlug,
            authorId: args.authorId,
            fromAuthor: args.fromAuthor,
            fromTag: args.fromTag,
            fromSearch: args.fromSearch,
            tutorials: args.tutorials,
            subject: args.subject),
        settings: data,
      );
    },
    _i8.NewsAuthorView: (data) {
      final args = data.getArgs<NewsAuthorViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.NewsAuthorView(key: args.key, authorSlug: args.authorSlug),
        settings: data,
      );
    },
    _i9.NewsImageView: (data) {
      final args = data.getArgs<NewsImageViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.NewsImageView(
            key: args.key, imgUrl: args.imgUrl, isDataUrl: args.isDataUrl),
        settings: data,
      );
    },
    _i10.CodeRadioView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.CodeRadioView(),
        settings: data,
      );
    },
    _i11.ChallengeTemplateView: (data) {
      final args = data.getArgs<ChallengeTemplateViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.ChallengeTemplateView(
            key: args.key,
            block: args.block,
            challengeId: args.challengeId,
            challengesCompleted: args.challengesCompleted),
        settings: data,
      );
    },
    _i12.ProfileView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.ProfileView(),
        settings: data,
      );
    },
    _i13.LearnLandingView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.LearnLandingView(),
        settings: data,
      );
    },
    _i14.NativeLoginView: (data) {
      final args = data.getArgs<NativeLoginViewArguments>(
        orElse: () => const NativeLoginViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i14.NativeLoginView(key: args.key, fromButton: args.fromButton),
        settings: data,
      );
    },
    _i15.SuperBlockView: (data) {
      final args = data.getArgs<SuperBlockViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.SuperBlockView(
            key: args.key,
            superBlockDashedName: args.superBlockDashedName,
            superBlockName: args.superBlockName,
            hasInternet: args.hasInternet),
        settings: data,
      );
    },
    _i16.SettingsView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.SettingsView(),
        settings: data,
      );
    },
    _i17.DeleteAccountView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i17.DeleteAccountView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class EpisodeViewArguments {
  const EpisodeViewArguments({
    this.key,
    required this.episode,
    required this.podcast,
  });

  final _i18.Key? key;

  final _i19.Episodes episode;

  final _i20.Podcasts podcast;

  @override
  String toString() {
    return '{"key": "$key", "episode": "$episode", "podcast": "$podcast"}';
  }

  @override
  bool operator ==(covariant EpisodeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.episode == episode &&
        other.podcast == podcast;
  }

  @override
  int get hashCode {
    return key.hashCode ^ episode.hashCode ^ podcast.hashCode;
  }
}

class NewsTutorialViewArguments {
  const NewsTutorialViewArguments({
    this.key,
    required this.refId,
    required this.title,
  });

  final _i18.Key? key;

  final String refId;

  final String? title;

  @override
  String toString() {
    return '{"key": "$key", "refId": "$refId", "title": "$title"}';
  }

  @override
  bool operator ==(covariant NewsTutorialViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.refId == refId && other.title == title;
  }

  @override
  int get hashCode {
    return key.hashCode ^ refId.hashCode ^ title.hashCode;
  }
}

class NewsBookmarkTutorialViewArguments {
  const NewsBookmarkTutorialViewArguments({
    this.key,
    required this.tutorial,
  });

  final _i18.Key? key;

  final _i21.BookmarkedTutorial tutorial;

  @override
  String toString() {
    return '{"key": "$key", "tutorial": "$tutorial"}';
  }

  @override
  bool operator ==(covariant NewsBookmarkTutorialViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.tutorial == tutorial;
  }

  @override
  int get hashCode {
    return key.hashCode ^ tutorial.hashCode;
  }
}

class NewsFeedViewArguments {
  const NewsFeedViewArguments({
    this.key,
    this.tagSlug = '',
    this.authorId = '',
    this.fromAuthor = false,
    this.fromTag = false,
    this.fromSearch = false,
    this.tutorials = const [],
    this.subject = '',
  });

  final _i18.Key? key;

  final String tagSlug;

  final String authorId;

  final bool fromAuthor;

  final bool fromTag;

  final bool fromSearch;

  final List<dynamic> tutorials;

  final String subject;

  @override
  String toString() {
    return '{"key": "$key", "tagSlug": "$tagSlug", "authorId": "$authorId", "fromAuthor": "$fromAuthor", "fromTag": "$fromTag", "fromSearch": "$fromSearch", "tutorials": "$tutorials", "subject": "$subject"}';
  }

  @override
  bool operator ==(covariant NewsFeedViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.tagSlug == tagSlug &&
        other.authorId == authorId &&
        other.fromAuthor == fromAuthor &&
        other.fromTag == fromTag &&
        other.fromSearch == fromSearch &&
        other.tutorials == tutorials &&
        other.subject == subject;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        tagSlug.hashCode ^
        authorId.hashCode ^
        fromAuthor.hashCode ^
        fromTag.hashCode ^
        fromSearch.hashCode ^
        tutorials.hashCode ^
        subject.hashCode;
  }
}

class NewsAuthorViewArguments {
  const NewsAuthorViewArguments({
    this.key,
    required this.authorSlug,
  });

  final _i18.Key? key;

  final String authorSlug;

  @override
  String toString() {
    return '{"key": "$key", "authorSlug": "$authorSlug"}';
  }

  @override
  bool operator ==(covariant NewsAuthorViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.authorSlug == authorSlug;
  }

  @override
  int get hashCode {
    return key.hashCode ^ authorSlug.hashCode;
  }
}

class NewsImageViewArguments {
  const NewsImageViewArguments({
    this.key,
    required this.imgUrl,
    required this.isDataUrl,
  });

  final _i18.Key? key;

  final String imgUrl;

  final bool isDataUrl;

  @override
  String toString() {
    return '{"key": "$key", "imgUrl": "$imgUrl", "isDataUrl": "$isDataUrl"}';
  }

  @override
  bool operator ==(covariant NewsImageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.imgUrl == imgUrl &&
        other.isDataUrl == isDataUrl;
  }

  @override
  int get hashCode {
    return key.hashCode ^ imgUrl.hashCode ^ isDataUrl.hashCode;
  }
}

class ChallengeTemplateViewArguments {
  const ChallengeTemplateViewArguments({
    this.key,
    required this.block,
    required this.challengeId,
    required this.challengesCompleted,
  });

  final _i18.Key? key;

  final _i22.Block block;

  final String challengeId;

  final int challengesCompleted;

  @override
  String toString() {
    return '{"key": "$key", "block": "$block", "challengeId": "$challengeId", "challengesCompleted": "$challengesCompleted"}';
  }

  @override
  bool operator ==(covariant ChallengeTemplateViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.block == block &&
        other.challengeId == challengeId &&
        other.challengesCompleted == challengesCompleted;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        block.hashCode ^
        challengeId.hashCode ^
        challengesCompleted.hashCode;
  }
}

class NativeLoginViewArguments {
  const NativeLoginViewArguments({
    this.key,
    this.fromButton = false,
  });

  final _i18.Key? key;

  final bool fromButton;

  @override
  String toString() {
    return '{"key": "$key", "fromButton": "$fromButton"}';
  }

  @override
  bool operator ==(covariant NativeLoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.fromButton == fromButton;
  }

  @override
  int get hashCode {
    return key.hashCode ^ fromButton.hashCode;
  }
}

class SuperBlockViewArguments {
  const SuperBlockViewArguments({
    this.key,
    required this.superBlockDashedName,
    required this.superBlockName,
    required this.hasInternet,
  });

  final _i18.Key? key;

  final String superBlockDashedName;

  final String superBlockName;

  final bool hasInternet;

  @override
  String toString() {
    return '{"key": "$key", "superBlockDashedName": "$superBlockDashedName", "superBlockName": "$superBlockName", "hasInternet": "$hasInternet"}';
  }

  @override
  bool operator ==(covariant SuperBlockViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.superBlockDashedName == superBlockDashedName &&
        other.superBlockName == superBlockName &&
        other.hasInternet == hasInternet;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        superBlockDashedName.hashCode ^
        superBlockName.hashCode ^
        hasInternet.hashCode;
  }
}

extension NavigatorStateExtension on _i23.NavigationService {
  Future<dynamic> navigateToNewsViewHandlerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.newsViewHandlerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPodcastListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.podcastListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEpisodeView({
    _i18.Key? key,
    required _i19.Episodes episode,
    required _i20.Podcasts podcast,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.episodeView,
        arguments:
            EpisodeViewArguments(key: key, episode: episode, podcast: podcast),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsTutorialView({
    _i18.Key? key,
    required String refId,
    required String? title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsTutorialView,
        arguments:
            NewsTutorialViewArguments(key: key, refId: refId, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsBookmarkTutorialView({
    _i18.Key? key,
    required _i21.BookmarkedTutorial tutorial,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsBookmarkTutorialView,
        arguments:
            NewsBookmarkTutorialViewArguments(key: key, tutorial: tutorial),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsFeedView({
    _i18.Key? key,
    String tagSlug = '',
    String authorId = '',
    bool fromAuthor = false,
    bool fromTag = false,
    bool fromSearch = false,
    List<dynamic> tutorials = const [],
    String subject = '',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsFeedView,
        arguments: NewsFeedViewArguments(
            key: key,
            tagSlug: tagSlug,
            authorId: authorId,
            fromAuthor: fromAuthor,
            fromTag: fromTag,
            fromSearch: fromSearch,
            tutorials: tutorials,
            subject: subject),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsAuthorView({
    _i18.Key? key,
    required String authorSlug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsAuthorView,
        arguments: NewsAuthorViewArguments(key: key, authorSlug: authorSlug),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsImageView({
    _i18.Key? key,
    required String imgUrl,
    required bool isDataUrl,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsImageView,
        arguments: NewsImageViewArguments(
            key: key, imgUrl: imgUrl, isDataUrl: isDataUrl),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCodeRadioView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.codeRadioView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChallengeTemplateView({
    _i18.Key? key,
    required _i22.Block block,
    required String challengeId,
    required int challengesCompleted,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.challengeTemplateView,
        arguments: ChallengeTemplateViewArguments(
            key: key,
            block: block,
            challengeId: challengeId,
            challengesCompleted: challengesCompleted),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLearnLandingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.learnLandingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNativeLoginView({
    _i18.Key? key,
    bool fromButton = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.nativeLoginView,
        arguments: NativeLoginViewArguments(key: key, fromButton: fromButton),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSuperBlockView({
    _i18.Key? key,
    required String superBlockDashedName,
    required String superBlockName,
    required bool hasInternet,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.superBlockView,
        arguments: SuperBlockViewArguments(
            key: key,
            superBlockDashedName: superBlockDashedName,
            superBlockName: superBlockName,
            hasInternet: hasInternet),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDeleteAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.deleteAccountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsViewHandlerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.newsViewHandlerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPodcastListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.podcastListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEpisodeView({
    _i18.Key? key,
    required _i19.Episodes episode,
    required _i20.Podcasts podcast,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.episodeView,
        arguments:
            EpisodeViewArguments(key: key, episode: episode, podcast: podcast),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsTutorialView({
    _i18.Key? key,
    required String refId,
    required String? title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsTutorialView,
        arguments:
            NewsTutorialViewArguments(key: key, refId: refId, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsBookmarkTutorialView({
    _i18.Key? key,
    required _i21.BookmarkedTutorial tutorial,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsBookmarkTutorialView,
        arguments:
            NewsBookmarkTutorialViewArguments(key: key, tutorial: tutorial),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsFeedView({
    _i18.Key? key,
    String tagSlug = '',
    String authorId = '',
    bool fromAuthor = false,
    bool fromTag = false,
    bool fromSearch = false,
    List<dynamic> tutorials = const [],
    String subject = '',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsFeedView,
        arguments: NewsFeedViewArguments(
            key: key,
            tagSlug: tagSlug,
            authorId: authorId,
            fromAuthor: fromAuthor,
            fromTag: fromTag,
            fromSearch: fromSearch,
            tutorials: tutorials,
            subject: subject),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsAuthorView({
    _i18.Key? key,
    required String authorSlug,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsAuthorView,
        arguments: NewsAuthorViewArguments(key: key, authorSlug: authorSlug),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsImageView({
    _i18.Key? key,
    required String imgUrl,
    required bool isDataUrl,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsImageView,
        arguments: NewsImageViewArguments(
            key: key, imgUrl: imgUrl, isDataUrl: isDataUrl),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCodeRadioView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.codeRadioView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChallengeTemplateView({
    _i18.Key? key,
    required _i22.Block block,
    required String challengeId,
    required int challengesCompleted,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.challengeTemplateView,
        arguments: ChallengeTemplateViewArguments(
            key: key,
            block: block,
            challengeId: challengeId,
            challengesCompleted: challengesCompleted),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLearnLandingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.learnLandingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNativeLoginView({
    _i18.Key? key,
    bool fromButton = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.nativeLoginView,
        arguments: NativeLoginViewArguments(key: key, fromButton: fromButton),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSuperBlockView({
    _i18.Key? key,
    required String superBlockDashedName,
    required String superBlockName,
    required bool hasInternet,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.superBlockView,
        arguments: SuperBlockViewArguments(
            key: key,
            superBlockDashedName: superBlockDashedName,
            superBlockName: superBlockName,
            hasInternet: hasInternet),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDeleteAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.deleteAccountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
