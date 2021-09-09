import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/forum-post-model.dart';
import 'package:freecodecamp/models/forum-user-model.dart';
import 'package:html/dom.dart' as dom;
import 'package:freecodecamp/widgets/forum/forum-postview.dart';
import 'package:url_launcher/url_launcher.dart';

class UserTemplate extends StatefulWidget {
  UserTemplate({Key? key, required this.username}) : super(key: key);
  late final String username;
  _UserTemplateState createState() => _UserTemplateState();
}

class _UserTemplateState extends State<UserTemplate> {
  late Future<User> userFuture;

  void initState() {
    userFuture = User.fetchUser(widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [userTemplateBuilder(context, userFuture)],
        ),
      ),
    );
  }
}

FutureBuilder userTemplateBuilder(context, future) {
  return FutureBuilder<User>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data;

          return Column(
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: ClipRect(
                        child: Align(
                          heightFactor: 0.5,
                          widthFactor: 1,
                          child: FadeInImage.assetNetwork(
                            placeholder:
                                'assets/images/placeholder-profile-img.png',
                            image: PostModel.parseProfileAvatUrl(
                                user!.profilePicture,
                                MediaQuery.of(context)
                                    .size
                                    .width
                                    .toInt()
                                    .toString()),
                            width: 360,
                          ),
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
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        user.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: user.bio != null ? 16 : 0, left: 16),
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                )
              ]),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(user.bio != null ? 16 : 0),
                          child: user.bio != null
                              ? Html(
                                  data: user.bio,
                                  style: {
                                    "body": Style(
                                        color: Colors.white,
                                        fontSize: FontSize.rem(1.2))
                                  },
                                  onLinkTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    launch(url!);
                                  },
                                )
                              : null))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: user.bio != null
                          ? EdgeInsets.only(left: 16.0, top: 8)
                          : EdgeInsets.only(left: 16),
                      child: Text(
                        'Joined ' + PostModel.parseDate(user.createdAt),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: Text(
                        'Seen ' + PostModel.parseDate(user.lastSeen),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserTopicTemplate(user: user),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserBadgeBuilder(user: user),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          throw Exception('Snapshot has error' + snapshot.error.toString());
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      });
}

class UserTopicTemplate extends StatelessWidget {
  const UserTopicTemplate({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Text('Topics',
                  style: TextStyle(color: Colors.white, fontSize: 28)),
            )
          ],
        ),
        FutureBuilder<List<UserTopic>?>(
          future: User.getUserTopics(user!.username, 5),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var topic = snapshot.data;
              return Column(
                children: [
                  UserTopicBuilder(topic: topic),
                ],
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }
}

class UserTopicBuilder extends StatelessWidget {
  const UserTopicBuilder({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final List<UserTopic>? topic;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topic!.length,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForumPostView(
                          refPostId: topic![index].id.toString(),
                          refSlug: topic![index].slug,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.white, width: 2))),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(topic![index].title,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    )
                  ]),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'posted ' +
                                PostModel.parseDate(topic![index].createdAt),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Likes ' + topic![index].likedCount.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Replies ' + topic![index].postCount.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserBadgeBuilder extends StatelessWidget {
  UserBadgeBuilder({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User? user;
  late final List<UserBadge> badges;

  @override
  Widget build(BuildContext context) {
    var future = User.fetchUserBadges(user!.username, 5);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Badges',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ],
          ),
          FutureBuilder<List<UserBadge>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var badge = snapshot.data;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network('https://via.placeholder.com/200')
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16.0, left: 16),
                                child: Text(
                                  badge![index].name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 16, bottom: 16),
                                  child: Text(
                                    User.parseBadgeDescription(
                                        badge[index].description),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    });
              } else if (snapshot.hasError) {
                throw Exception(snapshot.error);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
