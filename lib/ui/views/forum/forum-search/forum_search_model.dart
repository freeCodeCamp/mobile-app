import 'dart:developer' as dev;
import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class SearchModel {
  final int topicId;
  final String postUsername;
  final int postLikeCount;
  final String title;
  final String slug;

  SearchModel(
      {required this.title,
      required this.postLikeCount,
      required this.postUsername,
      required this.topicId,
      required this.slug});
}

class ForumSearchModel extends BaseViewModel {
  bool _queryToShort = true;
  bool get queryToShort => _queryToShort;

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  void checkQuery(value) {
    if (value.length <= 2) {
      _queryToShort = true;
      notifyListeners();
    } else {
      _queryToShort = false;
      _searchTerm = value;
      notifyListeners();
    }
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void goToPost(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostView,
        arguments: ForumPostViewArguments(id: id, slug: slug));
  }

  // only search post for now
  Future<List<SearchModel>?> search(String query) async {
    final response = await ForumConnect.connectAndGet(
        '/search/query?term=$query&in=title&status=public&order=latest');
    List<SearchModel> searchedPosts = [];

    List posts = json.decode(response.body)['topics'];
    dev.log(posts.toString());

    if (query.length <= 2 || posts.isEmpty) {
      return null;
    }

    if (response.statusCode == 200) {
      for (int i = 0; i < posts.length; i++) {
        searchedPosts.add(SearchModel(
            title: posts[i]['title'],
            postLikeCount: posts[i]['like_count'],
            postUsername: posts[i]['username'],
            topicId: posts[i]["id"],
            slug: posts[i]["slug"]));
      }
      dev.log(searchedPosts.toString());
      return searchedPosts;
    }

    throw Exception(response.body);
  }
}
