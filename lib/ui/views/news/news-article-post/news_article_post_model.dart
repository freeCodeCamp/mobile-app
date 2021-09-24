import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

// TODO: make this usable with news_feed_model
class Article {
  final String author;
  final String authorImage;
  final String articleId;
  final String articleTitle;
  final String articleUrl;
  final String articleText;
  final String articleImage;

  Article(
      {required this.author,
      required this.authorImage,
      required this.articleId,
      required this.articleTitle,
      required this.articleUrl,
      required this.articleText,
      required this.articleImage});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        author: json['posts'][0]['primary_author']['name'],
        authorImage: json['posts'][0]['primary_author']['profile_image'],
        articleId: json['posts'][0]['id'],
        articleTitle: json['posts'][0]['title'],
        articleUrl: json['posts'][0]['url'],
        articleText: json['posts'][0]['html'],
        articleImage: json['posts'][0]['feature_image']);
  }
}

class NewsArticlePostViewModel extends BaseViewModel {
  late Future<Article> _articleFuture;

  Future<Article> get articleFuture => _articleFuture;

  void initState(id) {
    _articleFuture = fetchArticle(id);
  }

  Future<Article> fetchArticle(articleId) async {
    await dotenv.load(fileName: ".env");

    final response = await http.get(Uri.parse(
        'https://www.freecodecamp.org/news/ghost/api/v3/content/posts/$articleId/?key=${dotenv.env['NEWSKEY']}&include=authors'));

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
