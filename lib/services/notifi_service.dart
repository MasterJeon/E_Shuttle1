import 'package:e_shuttle/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


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
            (int id, String? title, String? body, String? payload) async {
               // Handle what happens when a local notification is tapped on iOS
            },
          );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, 
        iOS: initializationSettingsIOS,
      );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
              _handleNotificationClick(notificationResponse);
            },
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
        int id = 0, 
        String? title, 
        String? body, 
        String? payLoad,
        }) async {
        await notificationsPlugin.show(
        id, title, body, await notificationDetails(),
        );
        saveNotification(title, body);
  }

  Future<void>  saveNotification(String? title, String? body) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];
    
    // Add the new notification
    final newNotification = jsonEncode({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
    });
    notifications.add(newNotification);

    // Save updated notifications list
    prefs.setStringList('notifications', notifications);
    _cleanOldNotifications();
  }

  Future<void> _cleanOldNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];
    final now = DateTime.now();

  // Keep only notifications from the last 30 days
  final recentNotifications = notifications.where((notif) {
    try {
      final map = jsonDecode(notif);
      final timestamp = DateTime.parse(map['timestamp']);
      return now.difference(timestamp).inDays <= 30;
    } catch (e) {
      return false; // In case of error, exclude the notification
    }
  }).toList();

    // Save the filtered list
    prefs.setStringList('notifications', recentNotifications);
  }

Future<List<Map<String, String>>> getNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final notifications = prefs.getStringList('notifications') ?? [];

  return notifications.map((notif) {
    try {
      final map = jsonDecode(notif);
      return {
        'title': map['title']?.toString() ?? 'No Title',
        'body': map['body']?.toString() ?? 'No Body',
        'timestamp': map['timestamp']?.toString() ?? '',
      };
    } catch (e) {
      // Handle any errors in decoding the notification
      return {
        'title': 'Invalid Data',
        'body': 'Unable to decode notification',
        'timestamp': '',
      };
    }
  }).toList();
}


  void _handleNotificationClick(NotificationResponse response) {
    // Assuming the app's navigator key is set up globally
    navigatorKey.currentState?.pushNamed('/notificationpage');
  }
}
