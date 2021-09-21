import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_post_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_model.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkViewWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewsBookmarkViewWidget({Key? key, required this.article}) : super(key: key);
  final Article article;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) => model.isArticleBookmarked(article),
        builder: (context, model, child) => Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () {
                  model.bookmarkAndUnbookmark(article);
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF0a0a23)),
                icon: Icon(
                    model.bookmarked
                        ? Icons.bookmark_sharp
                        : Icons.bookmark_border_sharp,
                    color: Colors.white),
                label: Text(
                  model.bookmarked
                      ? 'Article is bookmarked'
                      : 'Bookmark for offline usage',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ));
  }
}
