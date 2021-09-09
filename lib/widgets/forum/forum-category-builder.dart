import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum-category-model.dart';

import 'forum-category-feed.dart';
import 'forum-connect.dart';

class CategoryBuilder extends StatefulWidget {
  _CategoryBuilderState createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  late Future<List<dynamic>?> categoryFuture;
  void initState() {
    super.initState();
    categoryFuture = fetchList();
  }

  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>?> fetchList() async {
    final response = await ForumConnect.connectAndGet('/categories');

    if (response.statusCode == 200) {
      return CategoryList.returnCategories(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var categories = snapshot.data;
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryTemplate(categories: categories, index: index);
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}
