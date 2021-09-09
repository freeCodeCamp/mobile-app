// this fetches a list of categories provided by the Discourse API
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

class Category {}
