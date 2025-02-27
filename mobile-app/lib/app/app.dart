import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/firebase/analytics_service.dart';
import 'package:freecodecamp/service/firebase/remote_config_service.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/service/locale_service.dart';
import 'package:freecodecamp/service/navigation/quick_actions_service.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:freecodecamp/service/podcast/download_service.dart';
import 'package:freecodecamp/service/podcast/notification_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/news/api_service.dart';

import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/template_view.dart';
import 'package:freecodecamp/ui/views/learn/landing/landing_view.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart';
import 'package:freecodecamp/ui/views/login/native_login_view.dart';
import 'package:freecodecamp/ui/views/news/news-author/news_author_view.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_view.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart';
import 'package:freecodecamp/ui/views/news/news-view-handler/news_view_handler_view.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart';
import 'package:freecodecamp/ui/views/profile/profile_view.dart';
import 'package:freecodecamp/ui/views/settings/delete-account/delete_account_view.dart';
import 'package:freecodecamp/ui/views/settings/settings_view.dart';

import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// Run 'flutter pub run build_runner build --delete-conflicting-outputs' after any changes in this file to generate updated files
@StackedApp(
  routes: [
    MaterialRoute(page: NewsViewHandlerView),
    MaterialRoute(page: PodcastListView),
    MaterialRoute(page: EpisodeView),
    MaterialRoute(page: NewsTutorialView),
    MaterialRoute(page: NewsBookmarkTutorialView),
    MaterialRoute(page: NewsFeedView),
    MaterialRoute(page: NewsAuthorView),
    MaterialRoute(page: NewsImageView),
    MaterialRoute(page: CodeRadioView),
    MaterialRoute(page: ChallengeTemplateView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: LearnLandingView, initial: true),
    MaterialRoute(page: NativeLoginView),
    MaterialRoute(page: SuperBlockView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: DeleteAccountView)
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DatabaseMigrationService),
    LazySingleton(classType: PodcastsDatabaseService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: DeveloperService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: AppAudioService),
    LazySingleton(classType: DownloadService),
    LazySingleton(classType: LearnService),
    LazySingleton(classType: LearnFileService),
    LazySingleton(classType: LearnOfflineService),
    LazySingleton(classType: QuickActionsService),
    LazySingleton(classType: AnalyticsService),
    LazySingleton(classType: RemoteConfigService),
    LazySingleton(classType: BookmarksDatabaseService),
    LazySingleton(classType: LocaleService),
    LazySingleton(classType: DioService),
    LazySingleton(classType: NewsApiServive),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  //Serves no purpose besides having an annotation attached to it
}
