import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:developer' as dev;

import '../forum_connect.dart';

class PostViewModel extends BaseViewModel {
  late Future<PostModel> _future;
  Future<PostModel> get future => _future;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isEditingPost = false;
  bool get isEditingPost => _isEditingPost;

  bool _recentlyDeletedPost = false;
  bool get recentlyDeletedPost => _recentlyDeletedPost;

  String _recentlyDeletedPostId = '';
  String get recentlyDeletedPostId => _recentlyDeletedPostId;

  String _editedPostId = '';
  String get editedPostId => _editedPostId;

  Timer? _timer;

  final commentText = TextEditingController();

  void initState(slug, id) async {
    _future = fetchPost(id, slug);
    _isLoggedIn = await checkLoggedIn();
    enableTimer(id, slug);
    notifyListeners();
  }

  void disposeTimer() {
    _timer!.cancel();
    notifyListeners();
  }

  void enableTimer(id, slug) {
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      _recentlyDeletedPost = false;
      _recentlyDeletedPostId = '';
      _future = fetchPost(id, slug);
      notifyListeners();
    });
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<PostModel> fetchPost(String id, String slug) async {
    final response = await ForumConnect.connectAndGet('/t/$slug/$id');
    if (response.statusCode == 200) {
      return PostModel.fromPostJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  void editPost(String postId, String commentValue) {
    _isEditingPost = true;
    _editedPostId = postId;
    commentText.text = commentValue;
    notifyListeners();
  }

  Future<void> updatePost(postId, postSlug) async {
    Map<String, dynamic> body = {
      "post": {"raw": commentText.text}
    };

    if (commentText.text.isNotEmpty) {
      await ForumConnect.connectAndPut('/posts/$_editedPostId', body);
      _future = fetchPost(postId, postSlug);
      notifyListeners();
    }

    _isEditingPost = false;
    _editedPostId = '';

    notifyListeners();
  }

  void cancelUpdatePost() {
    _isEditingPost = false;
    _editedPostId = '';
    notifyListeners();
  }

  Future<void> deletePost(commentId, postId, postSlug) async {
    final response =
        await ForumConnect.connectAnDelete('/posts/$commentId', {});

    Timer? _deleteTimer;

    if (response.statusCode == 200) {
      _recentlyDeletedPost = true;
      _recentlyDeletedPostId = commentId;

      notifyListeners();
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> recoverPost(id) async {
    final response = await ForumConnect.connectAndPut('/posts/$id/recover', {});

    if (response.statusCode == 200) {
      _recentlyDeletedPost = false;
      _recentlyDeletedPostId = '';
      notifyListeners();
    } else {
      throw Exception(response.body);
    }
  }
  // this parses different urls based on the cdn (Discourse or FCC)

  static String parseProfileAvatUrl(
    String? url,
    String size,
  ) {
    List urlPart = url!.split('{size}');
    String avatarUrl = '';
    String baseUrl = 'https://forum.freecodecamp.org';
    bool fromDiscourse = urlPart[0]
        .toString()
        .contains(RegExp(r'discourse-cdn', caseSensitive: false));

    if (urlPart.length > 1) {
      avatarUrl = urlPart[0] + size + urlPart[1];
    }

    if (urlPart.length == 1) {
      return urlPart[0];
    } else if (fromDiscourse) {
      return avatarUrl;
    } else {
      return baseUrl + avatarUrl;
    }
  }

  // This provides a random border color to the profile pictures

  Color randomBorderColor() {
    final random = Random();

    List borderColor = [
      const Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
    ];

    int index = random.nextInt(borderColor.length);

    return borderColor[index];
  }

  // This returns a parsed date from ISO to : 20 minutes ago
  static String parseDate(String date) {
    return Jiffy(date).fromNow();
  }

  // This returns a parsed url for sharing a post
  void parseShareUrl(BuildContext context, String slug) {
    Share.share('https://forum.freecodecamp.org/t/$slug',
        subject: 'Question from the freecodecamp forum');
  }

  final NavigationService _navigationService = locator<NavigationService>();
  void goToUserProfile(username) {
    _navigationService.navigateTo(Routes.forumUserView,
        arguments: ForumUserViewArguments(username: username));
  }
}
