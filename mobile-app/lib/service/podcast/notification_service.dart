import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This is a singleton class and initialized only once
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Random random = Random();

  factory NotificationService() {
    return _notificationService;
  }

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {
      dev.log('onDidReceiveLocalNotification: $id, $title, $body, $payload');
    });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification(String title, String body) async {
    // Check up more on the below values here
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'fcc-notif-channel',
      'podcast-episodes',
      channelDescription: 'Channel description',
      priority: Priority.high,
      importance: Importance.max,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(threadIdentifier: 'fcc-ios-notif-channel');

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      random.nextInt(pow(2, 31).toInt() - 1),
      title,
      body,
      platformChannelSpecifics,
    );
  }

  NotificationService._internal();
}
