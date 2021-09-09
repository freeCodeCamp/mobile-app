import 'dart:convert';
import 'dart:developer' as dev;
import 'package:freecodecamp/widgets/forum/forum-connect.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';

// This file has all "needed" user fields with types provided by the Discourse api
// read the Discourse API documentation for more user fields and type them here if needed

class User {
  final String username;
  final String name;
  final String profilePicture;
  final String lastSeen;
  final String createdAt;
  final String title;
  final String? bio;
  final String dateOfBirth;
  final bool ignored;
  final bool muted;
  final bool canSendPrivateMessages;
  final bool canSendPrivateMessageToUser;
  final bool isModerator;
  final bool isAdmin;
  final int trustLevel;
  final int badgeCount;
  final int postCount;
  final List<dynamic> badges;

  User({
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.lastSeen,
    required this.createdAt,
    required this.title,
    required this.bio,
    required this.dateOfBirth,
    required this.ignored,
    required this.muted,
    required this.canSendPrivateMessages,
    required this.canSendPrivateMessageToUser,
    required this.isModerator,
    required this.isAdmin,
    required this.trustLevel,
    required this.badgeCount,
    required this.postCount,
    required this.badges,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      username: data['user']['username'],
      name: data['user']['name'],
      profilePicture: data['user']['avatar_template'],
      lastSeen: data['user']['last_seen_at'],
      createdAt: data['user']['created_at'],
      title: data['user']['title'],
      bio: data['user']['bio_excerpt'],
      dateOfBirth: data['user']['date_of_birth'],
      ignored: data['user']['ignored'],
      muted: data['user']['muted'],
      canSendPrivateMessages: data['user']['can_send_private_messages'],
      canSendPrivateMessageToUser: data['user']
          ['can_send_private_messages_to_user'],
      isModerator: data['user']['moderator'],
      isAdmin: data['user']['admin'],
      trustLevel: data['user']['trust_level'],
      badgeCount: data['user']['badge_count'],
      postCount: data['user']['post_count'],
      badges: data['badges'],
    );
  }

  static Future<User> fetchUser(String username) async {
    final response = await ForumConnect.connectAndGet('/u/$username');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user data: ' + response.body.toString());
  }

  static Future<List<UserTopic>?> getUserTopics(username, amount) async {
    UserSummary userSummary = await fetchUserSummary(username);

    List<dynamic>? userTopics = userSummary.topics;
    List<UserTopic>? topics = [];

    for (int i = 0; i < userTopics!.length; i++) {
      if (i == amount) break;
      topics.add(UserTopic.fromJson(userTopics[i]));
    }
    return topics;
  }

  // A summary fetched from the Discourse API used by the user profile file.

  static Future<UserSummary> fetchUserSummary(String username) async {
    final response = await ForumConnect.connectAndGet('/u/$username/summary');
    if (response.statusCode == 200) {
      return UserSummary.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user summary: ' + response.body.toString());
  }

  // A badge of badges fetched from the Discourse api

  static Future<List<UserBadge>> fetchUserBadges(
      String username, int max) async {
    final response = await ForumConnect.connectAndGet('/user-badges/$username');
    List<dynamic> badgesJson = jsonDecode(response.body)['badges'];
    List<UserBadge> badges = [];
    if (response.statusCode == 200) {
      for (int i = 0; i < badgesJson.length; i++) {
        if (i == max) break;
        badges.add(UserBadge.fromJson(badgesJson[i]));
      }
    } else {
      throw Exception('failed loading badges: ' + response.body.toString());
    }

    return badges;
  }

  // static FaIcon discourseIconParser(String icon) {
  //   List iconParts = icon.split('-');
  //   dev.log(iconParts[1]);
  //   return FaIcon(iconParts[1]);
  // }

  // This parses the badge description so it has no anchor tags.

  static String parseBadgeDescription(String desc) {
    final document = parse(desc);
    final String parsedDesc = parse(document.body!.text).documentElement!.text;
    return parsedDesc;
  }
}

// An user topic is different from a post because it's fetched from a different endpoint.

class UserTopic {
  final int id;
  final int postCount;
  final int likedCount;
  final String title;
  final String slug;
  final String createdAt;

  UserTopic(
      {required this.id,
      required this.postCount,
      required this.title,
      required this.slug,
      required this.createdAt,
      required this.likedCount});

  factory UserTopic.fromJson(Map<String, dynamic> data) {
    return UserTopic(
        id: data['id'],
        postCount: data['posts_count'],
        title: data['title'],
        slug: data['slug'],
        createdAt: data['created_at'],
        likedCount: data['like_count']);
  }
}

class UserBadge {
  final int id;
  final int grantCount;
  final String name;
  final String description;
  final String slug;
  final String imageUrl;
  final String icon;
  final bool allowTitle;
  final bool listable;
  final bool enabled;
  final bool manuallyGrantable;

  UserBadge({
    required this.id,
    required this.grantCount,
    required this.name,
    required this.description,
    required this.slug,
    required this.imageUrl,
    required this.icon,
    required this.allowTitle,
    required this.listable,
    required this.enabled,
    required this.manuallyGrantable,
  });

  factory UserBadge.fromJson(Map<String, dynamic> data) {
    return UserBadge(
        id: data['id'],
        grantCount: data['grant_count'],
        name: data['name'],
        description: data['description'],
        slug: data['slug'],
        imageUrl: data['image_url'],
        icon: data['icon'],
        allowTitle: data['allow_title'],
        listable: data['listable'],
        enabled: data['enabled'],
        manuallyGrantable: data['manually_grantable']);
  }
}

class UserSummary {
  final int likesGiven;
  final int likesReceived;
  final int topicEnterd;
  final int postRead;
  final int daysVisited;
  final int topicCount;
  final int postCount;
  final int solvedCount;
  final bool canSeeStats;
  final List? topics;

  UserSummary(
      {required this.likesGiven,
      required this.likesReceived,
      required this.topicEnterd,
      required this.postRead,
      required this.daysVisited,
      required this.topicCount,
      required this.postCount,
      required this.solvedCount,
      required this.canSeeStats,
      this.topics});

  factory UserSummary.fromJson(Map<String, dynamic> data) {
    return UserSummary(
        likesGiven: data['user_summary']['likes_given'],
        likesReceived: data['user_summary']['likes_received'],
        topicEnterd: data['user_summary']['topics_entered'],
        postRead: data['user_summary']['post_read_count'],
        daysVisited: data['user_summary']['days_visited'],
        topicCount: data['user_summary']['topic_count'],
        postCount: data['user_summary']['post_count'],
        solvedCount: data['user_summary']['solved_count'],
        canSeeStats: data['user_summary']['can_see_summary_stats'],
        topics: data['topics']);
  }
}
