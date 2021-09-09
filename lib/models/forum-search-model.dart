import 'package:freecodecamp/widgets/forum/forum-connect.dart';
import 'dart:developer' as dev;
import 'dart:convert';

class SearchResult {
  final int topicId;
  final String postUsername;
  final int postLikeCount;
  final String title;
  final String slug;

  static void error(String body) {
    dev.log(body.toString());
  }

  SearchResult(
      {required this.title,
      required this.postLikeCount,
      required this.postUsername,
      required this.topicId,
      required this.slug});
}

class SearchModel {
  // only search post for now
  static Future<List<SearchResult>?> search(String query) async {
    final response = await ForumConnect.connectAndGet(
        '/search/query?term=$query&in=title&status=public&order=latest');
    List<SearchResult> searchedPosts = [];

    List posts = json.decode(response.body)['topics'];
    dev.log(posts.toString());

    if (query.length <= 2 || posts.length == 0) {
      return null;
    }

    if (response.statusCode == 200) {
      for (int i = 0; i < posts.length; i++) {
        searchedPosts.add(SearchResult(
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
