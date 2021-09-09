import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/widgets/drawer.dart';
import 'package:freecodecamp/widgets/forum/forum-post-feed.dart';
import 'package:freecodecamp/widgets/forum/forum-search.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'forum-category-builder.dart';
import 'forum-login.dart';

class ForumCategoryView extends StatefulWidget {
  _ForumCategoryViewState createState() => _ForumCategoryViewState();
}

class _ForumCategoryViewState extends State<ForumCategoryView> {
  int _index = 1;

  void _onTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  List views = <dynamic>[
    ForumLoginTemplate(),
    CategoryBuilder(),
    ForumSearch(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0a0a23),
          title: Text('categories'),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        drawer: Menu(),
        body: views.elementAt(_index),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF0a0a23),
          unselectedItemColor: Colors.white,
          selectedItemColor: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: 'new'),
            BottomNavigationBarItem(
                icon: Icon(Icons.article, color: Colors.white),
                label: 'categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined, color: Colors.white),
                label: 'search')
          ],
          currentIndex: _index,
          onTap: _onTapped,
        ));
  }
}

class CategoryTemplate extends StatelessWidget {
  CategoryTemplate({
    Key? key,
    required this.categories,
    required this.index,
  }) : super(key: key);

  final List? categories;

  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForumPostFeed(
                      id: categories?[index]["id"],
                      slug: categories?[index]["slug"],
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    width: 5,
                    color: HexColor(
                      "#" + categories?[index]["color"],
                    )))),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(categories?[index]["name"],
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: categories?[index]["description"],
                          style: {
                            "body": Style(
                                color: Colors.white,
                                fontSize: FontSize.rem(1.2))
                          },
                          onLinkTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            launch(url!);
                          },
                        )))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      categories![index]["topics_week"].toString() +
                          ' new topics this week',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
