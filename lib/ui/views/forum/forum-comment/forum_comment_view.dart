import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_model.dart';
import 'package:stacked/stacked.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

class ForumCommentView extends StatelessWidget {
  late final List<PostModel> comments;
  // ignore: prefer_const_constructors_in_immutables
  ForumCommentView({Key? key, required this.comments}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        builder: (context, model, child) => ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var post = comments[index];
              dev.log('post');
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      model.goToUserProfile(post.username);
                    },
                    child: Row(
                      children: [
                        Row(children: [
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
                                        image:
                                            PostViewModel.parseProfileAvatUrl(
                                                post.profieImage, "60"))),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                post.username,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ]),
                      ],
                    ),
                  ),
                  commentHtml(index, context, comments, model),
                ],
              );
            }));
  }
}

Column commentHtml(int index, BuildContext context, List<PostModel> posts,
    PostViewModel model) {
  var post = posts[index];
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                shrinkWrap: true,
                data: post.postHtml,
                style: {
                  "aside":
                      Style(border: Border.all(width: 2, color: Colors.white)),
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
                    backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                  ),
                  "code": Style(
                    backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                  ),
                  "tr": Style(
                      border:
                          const Border(bottom: BorderSide(color: Colors.grey)),
                      backgroundColor: Colors.white),
                  "th": Style(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
                    color: Colors.black,
                  ),
                  "td": Style(
                    padding: const EdgeInsets.all(12),
                    color: Colors.black,
                    alignment: Alignment.topLeft,
                  ),
                },
                customRender: {
                  "table": (context, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (context.tree as TableLayoutElement)
                          .toWidget(context),
                    );
                  },
                  "code": (context, child) {
                    var classList = context.tree.elementClasses;
                    if (classList.isNotEmpty && classList[0] == 'lang-auto') {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 100,
                          maxHeight: 250,
                        ),
                        child: SyntaxView(
                          code: context.tree.element?.text as String,
                          syntax: Syntax.JAVASCRIPT,
                          syntaxTheme: SyntaxTheme.vscodeDark(),
                          fontSize: 16.0,
                          withZoom: false,
                          withLinesCount: false,
                          expanded: true,
                        ),
                      );
                    }
                  }
                },
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(url!);
                },
              ),
            ),
          )
        ],
      ),
      Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: Colors.white))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'posted ' + PostViewModel.parseDate(post.postCreateDate),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                model.parseShareUrl(context, post.postSlug);
              },
              icon: const Icon(Icons.share_outlined),
              color: Colors.white,
            )
          ],
        ),
      ),
    ],
  );
}
