import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class PostList {
  static List<dynamic> returnPosts(Map<String, dynamic> data) {
    return data["topic_list"]["topics"];
  }

  static List<dynamic> returnCategoryUsers(Map<String, dynamic> data) {
    return data["users"];
  }

  static List<dynamic> returnProfilePictures(Map<String, dynamic> data) {
    return data["details"]["participants"];
  }

  PostList.error() {
    throw Exception('Unable to load posts');
  }

  PostList.errorProfile() {
    throw Exception('unable to load post profile pictures');
  }
}

class ForumPostFeedModel extends BaseViewModel {
  late Future<List<dynamic>?> _future;
  Future<List<dynamic>?> get future => _future;

  void initState(slug, id) {
    _future = fetchPosts(slug, id);
  }

  Future<List<dynamic>?> fetchPosts(slug, id) async {
    final response = await ForumConnect.connectAndGet('/c/$slug/$id');

    if (response.statusCode == 200) {
      return PostList.returnPosts(json.decode(response.body));
    } else {
      PostList.error();
    }
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void navigateToPost(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostView,
        arguments: ForumPostViewArguments(id: id, slug: slug));
  }
}
