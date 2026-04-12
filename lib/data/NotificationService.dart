import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();
  static const channelId = 'flutter_plant_channel';
  static const channelName = 'Flutter_Plants';
  static const channelDescription = 'Channel for Notifications from the Flutter Plant App';

  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void init() async {
    final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );
    final initSettings = InitializationSettings(android: initSettingsAndroid, iOS: initSettingsIOS);
    notificationsPlugin.initialize(settings: initSettings);

    if (Platform.isAndroid) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }
  static Future<void> canceledNotification() async {
    await notificationsPlugin.cancelAll();
    print('cancel Notification');
  }

  static Future<void> scheduleNotification({
    required TimeOfDay time
}) async {
    const NotificationDetails details =
    NotificationDetails(
      //For Android
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
      ),
      //For IOS
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // await notificationsPlugin.show(id: 0, notificationDetails: details);
    await notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Pflanzen',
      body: 'Deine Pflanzen brauchen Wasser.',
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        scheduledDate: tz.TZDateTime(
          tz.local,
          time.hour,
          time.minute,
        ),
        notificationDetails: details
    );
    print('notification set');
    print(notificationsPlugin.getActiveNotifications());
  }
}
