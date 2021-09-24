import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_model.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkPostView extends StatelessWidget {
  final BookmarkedArticle article;

  const NewsBookmarkPostView({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) => model.isArticleBookmarked(article),
        onDispose: (model) => model.updateListView(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: const Text('BOOKMARKED ARTICLE'),
              centerTitle: true,
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              actions: [
                IconButton(
                    iconSize: 40,
                    onPressed: () {
                      model.bookmarkAndUnbookmark(article);
                    },
                    icon: model.bookmarked
                        ? const Icon(Icons.bookmark_sharp, color: Colors.white)
                        : const Icon(Icons.bookmark_border_sharp,
                            color: Colors.white))
              ],
            ),
            backgroundColor: const Color(0xFF0a0a23),
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
                                data: article.articleText,
                                style: {
                                  "body": Style(color: Colors.white),
                                  "p": Style(
                                      fontSize: FontSize.rem(1.35),
                                      lineHeight: LineHeight.em(1.2)),
                                  "ul": Style(fontSize: FontSize.xLarge),
                                  "li": Style(
                                    margin: const EdgeInsets.only(top: 8),
                                    fontSize: FontSize.rem(1.35),
                                  ),
                                  "pre": Style(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width,
                                      backgroundColor: const Color.fromRGBO(
                                          0x2A, 0x2A, 0x40, 1),
                                      padding: const EdgeInsets.all(25),
                                      textOverflow: TextOverflow.clip),
                                  "code": Style(
                                      backgroundColor: const Color.fromRGBO(
                                          0x2A, 0x2A, 0x40, 1)),
                                  "tr": Style(
                                      border: const Border(
                                          bottom:
                                              BorderSide(color: Colors.grey)),
                                      backgroundColor: Colors.white),
                                  "th": Style(
                                    padding: const EdgeInsets.all(12),
                                    backgroundColor: const Color.fromRGBO(
                                        0xdf, 0xdf, 0xe2, 1),
                                    color: Colors.black,
                                  ),
                                  "td": Style(
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.black,
                                    alignment: Alignment.topLeft,
                                  )
                                },
                                customRender: {
                                  "table": (context, child) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child:
                                          (context.tree as TableLayoutElement)
                                              .toWidget(context),
                                    );
                                  }
                                })),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
