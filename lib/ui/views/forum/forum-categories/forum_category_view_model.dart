import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../forum_connect.dart';

class CategoryList {
  static List<dynamic> returnCategories(Map<String, dynamic> data) {
    return data["category_list"]["categories"];
  }

  static bool canEditCategory(Map<String, dynamic> data) {
    return data["category_list"]["can_create_category"];
  }

  static bool canEditTopic(Map<String, dynamic> data) {
    return data["category_list"]["can_create_topic"];
  }

  CategoryList.error() {
    throw Exception('Categories could not be loaded!');
  }
}

class ForumCategoryViewModel extends BaseViewModel {
  late Future<List<dynamic>?> _future;
  Future<List<dynamic>?> get future => _future;
  final NavigationService _navigationService = locator<NavigationService>();

  int _index = 1;
  int get index => _index;

  void onTapped(tapped) {
    _index = tapped;
    notifyListeners();
  }

  void initState() {
    _future = fetchCategories();
  }

  void goToPosts(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostFeedView,
        arguments: ForumPostFeedViewArguments(slug: slug, id: id));
  }

  Future<List<dynamic>?> fetchCategories() async {
    final response = await ForumConnect.connectAndGet('/categories');

    if (response.statusCode == 200) {
      return CategoryList.returnCategories(jsonDecode(response.body));
    }
  }
}
