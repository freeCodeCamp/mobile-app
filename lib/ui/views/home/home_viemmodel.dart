import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  int index = 1;

  void onTapped(int index) {
    this.index = index;
    notifyListeners();
  }

  void goToBrowser(String url) {
    _navigationService.navigateTo(
      Routes.browserView,
      arguments: BrowserViewArguments(url: url),
    );
  }

  void navNonWebComponent(view) {
    switch (view) {
      case 'NEWS':
        _navigationService.navigateTo(Routes.homeView);
        break;
      case 'FORUM':
        _navigationService.navigateTo(Routes.forumCategoryView);
    }
  }
}
