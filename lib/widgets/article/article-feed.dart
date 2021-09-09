import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/article/article-bookmark-feed.dart';
import 'package:freecodecamp/widgets/article/article-search.dart';
import 'package:freecodecamp/widgets/drawer.dart';

import 'article-feed-builder.dart';
import 'article-view.dart';

class ArticleApp extends StatefulWidget {
  const ArticleApp({Key? key}) : super(key: key);

  @override
  _ArticleAppState createState() => _ArticleAppState();
}

// This shortens the titles if they have a longer length than 55 characters.

truncateStr(str) {
  if (str.length < 55) {
    return str;
  } else {
    return str.toString().substring(0, 55) + '...';
  }
}

// This returns random border colors for the profile images, these colors are
// defined in the fcc style guide https://bit.ly/3iEyqIl.

randomBorderColor() {
  final random = new Random();

  List borderColor = [
    Color.fromRGBO(0x99, 0xC9, 0xFF, 1),
    Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
    Color.fromRGBO(0xFF, 0xFF, 0x00, 1),
    Color.fromRGBO(0x80, 0x00, 0x80, 1),
  ];

  int index = random.nextInt(borderColor.length);

  return borderColor[index];
}

// The base url is returned without a defined size, this means that the orignal
// image size is returned (Which could be really big) luckly there is a theme
// we can use https://bit.ly/2U8QFfv, this reduces the image width and height and size

getArticleImage(imgUrl, context) {
  // Split the url
  List arr = imgUrl.toString().split('images');

  // Get the last index of the arr which is the name

  if (arr.length == 1) return imgUrl;

  double screenSize = MediaQuery.of(context).size.width;
  if (screenSize >= 600) {
    imgUrl = arr[0] + 'images/size/w1000' + arr[1];
  } else if (screenSize >= 300) {
    imgUrl = arr[0] + 'images/size/w600' + arr[1];
  } else if (screenSize >= 150) {
    imgUrl = arr[0] + 'images/size/w300' + arr[1];
  } else {
    imgUrl = arr[0] + 'images/size/w100' + arr[1];
  }

  return imgUrl;
}

getProfileImage(imgUrl) {
  List arr = imgUrl.toString().split('images');

  if (arr.length == 1) return imgUrl;

  return arr[0] + 'images/size/w60' + arr[1];
}

// The article class returns a confirmation that articles have been returned by
// the api.

class Article {
  final List<dynamic> post;

  Article({required this.post});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(post: json["posts"]);
  }
}

class _ArticleAppState extends State<ArticleApp> {
  int _index = 1;

  void _onTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  List views = <Widget>[
    BookmarkViewTemplate(),
    ArticleFeedBuilder(),
    ArticleSearch()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF0a0a23),
        title: Text('articles'),
        centerTitle: true,
      ),
      drawer: Menu(),
      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      body: views.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0a0a23),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_outline_sharp,
                color: Colors.white,
              ),
              label: 'Bookmarks'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.article_sharp,
                color: Colors.white,
              ),
              label: 'Articles'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search_sharp,
                color: Colors.white,
              ),
              label: 'Search')
        ],
        onTap: _onTapped,
        currentIndex: _index,
      ),
    );
  }
}

class ArticleTemplate extends StatelessWidget {
  const ArticleTemplate({
    Key? key,
    required this.articels,
    required this.i,
  }) : super(key: key);

  final List? articels;
  final int i;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ArticleViewTemplate(articleId: articels?[i]["id"])));
        },
        child: Column(
          children: [
            ArticleBanner(articels: articels, i: i),
            Row(
              children: [
                Expanded(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 50),
                  child: Container(
                    color: Color(0xFF0a0a23),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new InkWell(
                          child: new Text(truncateStr(articels?[i]["title"]),
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white)),
                        )),
                  ),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 55,
                      color: Color(0xFF0a0a23),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text(
                          (articels?[i]?['tags'].length > 0
                              ? "#${articels?[i]?['tags'][0]['name']}"
                              : "#freeCodeCamp"),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )),
                ),
                Expanded(
                    child: Container(
                  height: 55,
                  color: Color(0xFF0a0a23),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text("by ${articels?[i]['authors'][0]['name']}",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ))
              ],
            )
          ],
        ));
  }
}

class ArticleBanner extends StatelessWidget {
  const ArticleBanner({
    Key? key,
    required this.articels,
    required this.i,
  }) : super(key: key);

  final List? articels;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white)),
            child: GestureDetector(
                child: Image.network(
              getArticleImage(articels?[i]["feature_image"], context),
              height: 210,
              fit: BoxFit.fitWidth,
            ))),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: randomBorderColor())),
                child: Image.network(
                  articels?[i]['authors'][0]['profile_image'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                ),
              )),
        )
      ],
    );
  }
}
