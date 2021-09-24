import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-user/forum_user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class ForumUserView extends StatelessWidget {
  const ForumUserView({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumUserModel>.reactive(
        onModelReady: (model) => model.initState(username),
        viewModelBuilder: () => ForumUserModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              body: SingleChildScrollView(
                child: Column(
                  children: [userTemplateBuilder(context, model)],
                ),
              ),
            ));
  }
}

FutureBuilder userTemplateBuilder(context, model) {
  return FutureBuilder<User>(
      future: model.future,
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
                            image: PostViewModel.parseProfileAvatUrl(
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
                        style: const TextStyle(
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
                      style: const TextStyle(color: Colors.white, fontSize: 28),
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
                          ? const EdgeInsets.only(left: 16.0, top: 8)
                          : const EdgeInsets.only(left: 16),
                      child: Text(
                        'Joined ' + PostViewModel.parseDate(user.createdAt),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: Text(
                        'Seen ' + PostViewModel.parseDate(user.lastSeen),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: const Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserTopicTemplate(
                    user: user,
                    model: model,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: const Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserBadgeBuilder(user: user, model: model),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          throw Exception('Snapshot has error' + snapshot.error.toString());
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      });
}

class UserTopicTemplate extends StatelessWidget {
  const UserTopicTemplate({
    Key? key,
    required this.model,
    required this.user,
  }) : super(key: key);

  final User user;
  final ForumUserModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: Text('Topics',
                  style: TextStyle(color: Colors.white, fontSize: 28)),
            )
          ],
        ),
        FutureBuilder<List<UserTopic>?>(
          future: model.getUserTopics(user.username, 5),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var topic = snapshot.data;
              return Column(
                children: [
                  UserTopicBuilder(topic: topic, model: model),
                ],
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }
}

class UserTopicBuilder extends StatelessWidget {
  const UserTopicBuilder({Key? key, required this.topic, required this.model})
      : super(key: key);

  final List<UserTopic>? topic;
  final ForumUserModel model;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topic!.length,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            model.navigateToPost(topic![index].slug, topic![index].id);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.white, width: 2))),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(topic![index].title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                      ),
                    )
                  ]),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'posted ' +
                                PostViewModel.parseDate(
                                    topic![index].createdAt),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
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
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Replies ' + topic![index].postCount.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
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
  // ignore: prefer_const_constructors_in_immutables
  UserBadgeBuilder({Key? key, required this.user, required this.model})
      : super(key: key);
  final User user;
  final ForumUserModel model;
  late final List<UserBadge> badges;

  @override
  Widget build(BuildContext context) {
    var future = model.fetchUserBadges(user.username, 5);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16),
      child: Column(
        children: [
          Row(
            children: const [
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
                    physics: const ClampingScrollPhysics(),
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
                                  style: const TextStyle(
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
                                    ForumUserModel.parseBadgeDescription(
                                        badge[index].description),
                                    style: const TextStyle(
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

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
