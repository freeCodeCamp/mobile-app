import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'dart:developer' as dev;
import 'article-bookmark-feed.dart';

class ArticleBookmarkView extends StatefulWidget {
  ArticleBookmarkView({Key? key, this.article}) : super(key: key);

  late final BookmarkedArticle? article;

  @override
  _ArticleBookmarkViewState createState() => _ArticleBookmarkViewState();
}

class _ArticleBookmarkViewState extends State<ArticleBookmarkView> {
  void initState() {
    super.initState();
    articleInDb(widget.article);
  }

  bool isBookmarked = false;

  Map<String, dynamic> articleToMap(article) {
    return {
      "articleTitle": article!.articleTitle,
      "articleId": article!.articleId,
      "articleText": article!.articleText,
      "authorName": article!.authorName
    };
  }

  Future<void> insertArticle(BookmarkedArticle? article) async {
    final db = await openDbConnection();

    // Test if article is already in database

    List<Map> isInDatabase = await db.rawQuery(
        'SELECT * FROM bookmarks WHERE bookmark_id=?', [article!.bookmarkId]);

    if (isInDatabase.length == 0) {
      await db.insert('bookmarks', articleToMap(article),
          conflictAlgorithm: ConflictAlgorithm.replace);
      dev.log('article inserted in db!');
    } else {
      dev.log('article already in db!');
    }
  }

  Future<Database> openDbConnection() async {
    WidgetsFlutterBinding.ensureInitialized();

    String dbPath = await getDatabasesPath();
    String dbPathArticles = path.join(dbPath, "bookmarked-article.db");

    return openDatabase(dbPathArticles, version: 1);
  }

  Future<void> articleInDb(BookmarkedArticle? article) async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery(
        'SELECT * FROM bookmarks WHERE bookmark_id=?', [article!.bookmarkId]);

    dev.log(isInDatabase.length.toString());
    if (isInDatabase.length > 0) {
      setState(() {
        isBookmarked = true;
      });
    }
  }

  Future<void> bookmarkAndUnbookmark(BookmarkedArticle? article) async {
    final db = await openDbConnection();

    if (isBookmarked) {
      setState(() {
        isBookmarked = false;
      });
      await db.rawQuery(
          'DELETE FROM bookmarks WHERE bookmark_id=?', [article!.bookmarkId]);
    } else {
      setState(() {
        isBookmarked = true;
      });
      insertArticle(article);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BOOKMARKED ARTICLE'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          actions: [
            IconButton(
                iconSize: 40,
                onPressed: () {
                  bookmarkAndUnbookmark(widget.article);
                },
                icon: isBookmarked
                    ? Icon(Icons.bookmark_sharp, color: Colors.white)
                    : Icon(Icons.bookmark_border_sharp, color: Colors.white))
          ],
        ),
        backgroundColor: Color(0xFF0a0a23),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                            shrinkWrap: true,
                            data: widget.article!.articleText,
                            style: {
                              "body": Style(color: Colors.white),
                              "p": Style(
                                  fontSize: FontSize.rem(1.35),
                                  lineHeight: LineHeight.em(1.2)),
                              "ul": Style(fontSize: FontSize.xLarge),
                              "li": Style(
                                margin: EdgeInsets.only(top: 8),
                                fontSize: FontSize.rem(1.35),
                              ),
                              "pre": Style(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  backgroundColor:
                                      Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                  padding: EdgeInsets.all(25),
                                  textOverflow: TextOverflow.clip),
                              "code": Style(
                                  backgroundColor:
                                      Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                              "tr": Style(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey)),
                                  backgroundColor: Colors.white),
                              "th": Style(
                                padding: EdgeInsets.all(12),
                                backgroundColor:
                                    Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
                                color: Colors.black,
                              ),
                              "td": Style(
                                padding: EdgeInsets.all(12),
                                color: Colors.black,
                                alignment: Alignment.topLeft,
                              )
                            },
                            customRender: {
                              "table": (context, child) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: (context.tree as TableLayoutElement)
                                      .toWidget(context),
                                );
                              }
                            })),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
