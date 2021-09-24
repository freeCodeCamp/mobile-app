import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_model.dart';
import 'package:stacked/stacked.dart';

class ForumPostFeedView extends StatelessWidget {
  final String slug;
  final String id;

  const ForumPostFeedView({Key? key, required this.slug, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostFeedModel>.reactive(
        viewModelBuilder: () => ForumPostFeedModel(),
        onModelReady: (model) => model.initState(slug, id),
        builder: (context, model, child) => Scaffold(
              body: FutureBuilder<List<dynamic>?>(
                future: model.future,
                builder: (context, snapshot) {
                  //dev.log(snapshot.data.toString());
                  if (snapshot.hasData) {
                    var post = snapshot.data;

                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return postViewTemplate(post!, index, model);
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            ));
  }

  InkWell postViewTemplate(
      List<dynamic> post, int index, ForumPostFeedModel model) {
    return InkWell(
      onTap: () {
        model.navigateToPost(
          post[index]["slug"],
          post[index]["id"],
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 125),
        child: Container(
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 2, color: Colors.white))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(post[index]["title"],
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "posted " +
                            PostViewModel.parseDate(post[index]["created_at"]),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "activity " +
                            PostViewModel.parseDate(post[index]["bumped_at"]),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Views: ' + post[index]["views"].toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Replies: ' + post[index]["reply_count"].toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
