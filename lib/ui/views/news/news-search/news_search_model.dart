import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsSearchModel extends BaseViewModel {
  String _searchTerm = '';
  String get getSearchTerm => _searchTerm;

  final searchbarController = TextEditingController();
  final _navigationService = locator<NavigationService>();
  Future<List<AlgoliaObjectSnapshot>> search(String inputQuery) async {
    await dotenv.load(fileName: ".env");

    final Algolia algoliaInit = Algolia.init(
      applicationId: dotenv.env['ALGOLIAAPPID'] as String,
      apiKey: dotenv.env['ALGOLIAKEY'] as String,
    );

    Algolia algolia = algoliaInit;

    AlgoliaQuery query = algolia.instance.index('news').query(inputQuery);

    AlgoliaQuerySnapshot snap = await query.getObjects();

    List<AlgoliaObjectSnapshot> results = snap.hits;

    return results;
  }

  void setSearchTerm(value) {
    _searchTerm = value;
    notifyListeners();
  }

  void navigateToArticle(id) {
    _navigationService.navigateTo(Routes.newsArticlePostView,
        arguments: NewsArticlePostViewArguments(refId: id));
  }
}
