import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'article-feed.dart';

class ArticleFeedBuilder extends StatefulWidget {
  _ArticleFeedBuilderState createState() => _ArticleFeedBuilderState();
}

class _ArticleFeedBuilderState extends State<ArticleFeedBuilder> {
  List articles = [];
  bool searchBarActive = false;
  bool hasSearched = false;
  int page = 0;
  late Future<Article> futureArticle;
  ScrollController _scrollController = new ScrollController();

  final searchBarController = TextEditingController();
  void initState() {
    super.initState();
    futureArticle = fetchArticle();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchArticle();
      }
    });
  }

  Future<Article> fetchArticle() async {
    page++;

    await dotenv.load(fileName: ".env");

    String feedUrl =
        "https://www.freecodecamp.org/news/ghost/api/v3/content/posts/?key=${dotenv.env['NEWSKEY']}&include=tags,authors&page=" +
            page.toString() +
            "&fields=title,url,feature_image,id";

    dev.log(feedUrl);
    final response = await http.get(Uri.parse(feedUrl));
    if (response.statusCode == 200) {
      var newArticles = json.decode(response.body)['posts'];
      if (mounted) {
        setState(() {
          articles.addAll(newArticles);
        });
      }
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article>(
        future: futureArticle,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dev.log(articles.length.toString());
            return ListView.builder(
              controller: _scrollController,
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return ArticleTemplate(articels: articles, i: index);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        });
  }
}
