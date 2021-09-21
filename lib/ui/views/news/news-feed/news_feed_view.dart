import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_model.dart';
import 'package:stacked/stacked.dart';

import '../news_helpers.dart';
import 'news_feed_model.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsFeedModel>.reactive(
      viewModelBuilder: () => NewsFeedModel(),
      onModelReady: (model) => model.initState(),
      builder: (context, model, child) =>
          Scaffold(body: articleThumbnailBuilder(model, context)),
    );
  }

  articleThumbnailBuilder(NewsFeedModel model, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: model.articles.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext contex, int i) => NewsFeedLazyLoading(
            articleCreated: () {
              SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) => model.handleArticleLazyLoading(i));
            },
            child: InkWell(
                onTap: () {
                  model.navigateTo(model.articles[i].id);
                },
                child: thumbnailView(context, model, model.articles, i))));
  }

  Column thumbnailView(BuildContext context, NewsFeedModel model,
      List<Article>? articles, int i) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white)),
              height: 210,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                NewsHelper.getArticleImage(articles![i].featureImage, context),
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4, color: NewsHelper.randomBorderColor())),
                  child: Image.network(
                    articles[i].profileImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          color: const Color(0xFF0a0a23),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          NewsHelper.truncateStr(articles[i].title),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
                Row(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '#' + articles[i].tagName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          articles[i].authorName,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  )
                ]),
              ],
            ),
          ),
        )
      ],
    );
  }
}
