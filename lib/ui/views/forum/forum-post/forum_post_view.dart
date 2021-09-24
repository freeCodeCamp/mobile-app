// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-comment/forum_comment_view.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'forum_post_model.dart';

class ForumPostView extends StatelessWidget {
  final String id;
  final String slug;

  const ForumPostView({Key? key, required this.id, required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        onModelReady: (model) => model.initState(slug, id),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              body: SingleChildScrollView(child: postViewTemplate(model)),
            ));
  }
}

Column postViewTemplate(PostViewModel model) {
  List<PostModel> comments = [];

  return Column(
    children: [
      FutureBuilder<PostModel>(
          future: model.future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var post = snapshot.data;
              comments = [];
              comments.addAll(Comment.returnCommentList(post!.postComments));
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            post.postName as String,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      model.goToUserProfile(post.username);
                    },
                    child: Row(children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: model.randomBorderColor())),
                                child: FadeInImage.assetNetwork(
                                    height: 60,
                                    placeholder:
                                        'assets/images/placeholder-profile-img.png',
                                    image: PostViewModel.parseProfileAvatUrl(
                                        post.profieImage, "60"))),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            post.username,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 24, top: 16),
                    child: Row(
                      children: [
                        Text(
                          "posted " +
                              PostViewModel.parseDate(post.postCreateDate) +
                              " by " +
                              post.username,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 24, right: 8),
                        child: Row(
                          children: [
                            Text(
                              'SHARE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                model.parseShareUrl(context, post.postSlug);
                              },
                              icon: Icon(Icons.share_outlined),
                              color: Colors.white,
                            ),
                            Text(
                              'LIKE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8, left: 24, right: 8, top: 8),
                      child: Column(
                        children: [
                          Row(children: const [
                            Text(
                              'REPLIES',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                          Row(
                            children: [
                              Text(
                                (post.postComments!.length - 1).toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8, left: 24, right: 8, top: 8),
                      child: Column(children: [
                        Row(children: const [
                          Text(
                            'READS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                        Row(children: [
                          Text(
                            post.postReads.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ])
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8, left: 24, right: 8, top: 8),
                      child: Column(
                        children: [
                          Row(children: const [
                            Text(
                              'LIKES',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                          Row(children: [
                            Text(
                              post.postLikes.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ])
                        ],
                      ),
                    ),
                  ]),
                  Container(
                    color: Color(0xFF0a0a23),
                    child: htmlView(snapshot, context),
                  ),
                  ForumCommentView(comments: comments)
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          })
    ],
  );
}

Row htmlView(AsyncSnapshot<PostModel> post, BuildContext context) {
  return Row(
    children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Html(
          shrinkWrap: true,
          data: post.data!.postHtml,
          style: {
            "body": Style(color: Colors.white),
            "p": Style(
                fontSize: FontSize.rem(1.35), lineHeight: LineHeight.em(1.2)),
            "ul": Style(fontSize: FontSize.xLarge),
            "li": Style(
              margin: EdgeInsets.only(top: 8),
              fontSize: FontSize.rem(1.35),
            ),
            "pre": Style(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                textOverflow: TextOverflow.clip),
            "code": Style(backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
            "tr": Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
                backgroundColor: Colors.white),
            "th": Style(
              padding: EdgeInsets.all(12),
              backgroundColor: Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
              color: Colors.black,
            ),
            "td": Style(
              padding: EdgeInsets.all(12),
              color: Colors.black,
              alignment: Alignment.topLeft,
            ),
          },
          customRender: {
            "table": (context, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (context.tree as TableLayoutElement).toWidget(context),
              );
            },
            "code": (context, child) {
              var classList = context.tree.elementClasses;
              if (classList.isNotEmpty && classList[0] == 'lang-auto') {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 100, maxHeight: 500),
                  child: SyntaxView(
                    code: context.tree.element?.text as String,
                    syntax: Syntax.JAVASCRIPT,
                    syntaxTheme: SyntaxTheme.vscodeDark(),
                    fontSize: 16.0,
                    withZoom: true,
                    withLinesCount: false,
                    expanded: true,
                  ),
                );
              }
            },
            "aside": (context, child) {
              var link = context.tree.element!.attributes['data-onebox-src'];
              if (link!.isNotEmpty) {
                return InkWell(
                  onTap: () {
                    launch(link);
                  },
                  child: Text(
                    link,
                    style:
                        TextStyle(color: Color.fromRGBO(0x00, 0x2e, 0xad, 1)),
                  ),
                );
              }
            },
            "svg": (context, child) {
              var forbiddenClasses = context.tree.element!.className;
              if (forbiddenClasses
                  .toString()
                  .contains(RegExp(r'fa ', caseSensitive: false))) {
                return null;
              }
            },
            "image": (context, child) {
              var disableEmoijs = context.tree.element!.className;
              if (disableEmoijs.toString() == 'emoij') {
                return null;
              }
            }
          },
          onLinkTap: (String? url, RenderContext context,
              Map<String, String> attributes, dom.Element? element) {
            launch(url!);
          },
        ),
      ))
    ],
  );
}
