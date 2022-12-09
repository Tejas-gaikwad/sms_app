import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static final _notification = FlutterLocalNotificationsPlugin();

  static const androidNotificationDetails = AndroidNotificationDetails(
    '200',
    'Notification Channel',
    channelDescription: 'Test Nofication',
  );

  static Future init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: (i, j, k, l) async {}),
    );

    await _notification.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      log("onDidReceiveNotificationResponse called");
    });
  }

  static Future<void> showNotification(
      {int id = 1, String? title, String? description}) async {
    await _notification.show(
      1,
      title ?? '',
      description,
      const NotificationDetails(
        android: androidNotificationDetails,
      ),
    );
  }
}
