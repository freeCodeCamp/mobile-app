import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_builder.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-search/forum_search_view.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class ForumCategoryView extends StatelessWidget {
  ForumCategoryView({Key? key}) : super(key: key);

  List views = <dynamic>[
    const ForumLoginView(),
    const ForumCategoryBuilder(),
    const ForumSearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCategoryViewModel>.reactive(
        viewModelBuilder: () => ForumCategoryViewModel(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0a0a23),
              title: const Text('categories'),
              centerTitle: true,
            ),
            body: views.elementAt(model.index),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xFF0a0a23),
              unselectedItemColor: Colors.white,
              selectedItemColor: const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
              // ignore: prefer_const_literals_to_create_immutables
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: 'new'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.article, color: Colors.white),
                    label: 'categories'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined, color: Colors.white),
                    label: 'search')
              ],
              currentIndex: model.index,
              onTap: model.onTapped,
            )));
  }
}
