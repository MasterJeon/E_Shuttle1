import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();


  Future<void> initNotification() async {
    tz.initializeTimeZones(); // Initialize time zones

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo1');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, 
        iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(
      initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {}
            );
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId', 
          'channelName',
          importance: Importance.max,
          ),
        iOS: DarwinNotificationDetails(),
        );
  }

    Future<void> scheduleNotification({
    required int id,
    required String? title,
    required String? body,
    required DateTime scheduledTime,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future showNotification(
      {
        int id = 0, String? title, String? body, String? payLoad,
        }) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails(),
        );
  }
}

