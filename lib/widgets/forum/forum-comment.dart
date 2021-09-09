import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/models/forum-post-model.dart';
import 'package:freecodecamp/widgets/forum/forum-user-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class ForumComment extends StatefulWidget {
  ForumComment({Key? key, required this.comments}) : super(key: key);
  late final List<PostModel> comments;
  _ForumCommentState createState() => _ForumCommentState();
}

class _ForumCommentState extends State<ForumComment> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          var post = widget.comments[index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserTemplate(username: post.username)));
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
                                        color: PostModel.randomBorderColor())),
                                child: FadeInImage.assetNetwork(
                                    height: 60,
                                    placeholder:
                                        'assets/images/placeholder-profile-img.png',
                                    image: PostModel.parseProfileAvatUrl(
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
                  ],
                ),
              ),
              commentHtml(index, context),
            ],
          );
        });
  }

  Column commentHtml(int index, BuildContext context) {
    var post = widget.comments[index];
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
                    "aside": Style(
                        border: Border.all(width: 2, color: Colors.white)),
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
                      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    ),
                    "code": Style(
                      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    ),
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
                        child: (context.tree as TableLayoutElement)
                            .toWidget(context),
                      );
                    },
                    "code": (context, child) {
                      var classList = context.tree.elementClasses;
                      if (classList.length > 0 && classList[0] == 'lang-auto')
                        return ConstrainedBox(
                          constraints: BoxConstraints(
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
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 2, color: Colors.white))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'posted ' + PostModel.parseDate(post.postCreateDate),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.pinkAccent : Colors.white,
                  )),
              IconButton(
                onPressed: () {
                  PostModel.parseShareUrl(context, post.postSlug);
                },
                icon: Icon(Icons.share_outlined),
                color: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }
}
