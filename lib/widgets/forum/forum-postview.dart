import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/forum-post-model.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/widgets/forum/forum-comment.dart';
import 'package:freecodecamp/widgets/forum/forum-user-view.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class ForumPostView extends StatefulWidget {
  const ForumPostView(
      {Key? key, required this.refPostId, required this.refSlug})
      : super(key: key);

  final String refPostId;
  final String refSlug;

  _ForumPostViewState createState() => _ForumPostViewState();
}

class _ForumPostViewState extends State<ForumPostView> {
  late Future<PostModel> futurePost;
  List<PostModel> comments = [];
  bool isFavorited = false;
  void initState() {
    super.initState();
    futurePost = PostModel.fetchPost(widget.refPostId, widget.refSlug);
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      body: SingleChildScrollView(
        child: postViewTemplate(),
      ),
    );
  }

  Column postViewTemplate() {
    return Column(
      children: [
        FutureBuilder<PostModel>(
            future: futurePost,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserTemplate(username: post.username)));
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
                                          color:
                                              PostModel.randomBorderColor())),
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
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 16, left: 24, top: 16),
                      child: Row(
                        children: [
                          Text(
                            "posted " +
                                PostModel.parseDate(post.postCreateDate) +
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
                                  PostModel.parseShareUrl(
                                      context, post.postSlug);
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
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorited
                                        ? Colors.pinkAccent
                                        : Colors.white,
                                  )),
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
                            Row(children: [
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
                          Row(children: [
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
                            Row(children: [
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
                    ForumComment(comments: comments)
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
              "code":
                  Style(backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
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
                if (classList.length > 0 && classList[0] == 'lang-auto')
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
              },
              "aside": (context, child) {
                var link = context.tree.element!.attributes['data-onebox-src'];
                if (link!.length > 0) {
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
                    .contains(new RegExp(r'fa ', caseSensitive: false))) {
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
}
