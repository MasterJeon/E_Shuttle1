import 'package:flutter/material.dart';
import 'package:e_shuttle/services/notifi_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import your notification service

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, String>> _notifications = []; // List to hold notification data

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _configureFCM();
    _loadNotifications(); // Load past notifications on initialization
  }

  void _requestNotificationPermission() async {
    // Request notification permissions on iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureFCM() {
    // Get the device token for FCM
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      // You can send this token to your backend server if needed
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      NotificationService().showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      _saveNotification(message.notification?.title, message.notification?.body);
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
      Navigator.pushNamed(context, '/notificationpage'); // Navigate to NotificationsPage
    });
  }

  // Load past notifications
  Future<void> _loadNotifications() async {
    final notifications = await NotificationService().getNotifications();
    setState(() {
      _notifications = notifications;
    });
  }

    // Save the notification
  void _saveNotification(String? title, String? body) {
    NotificationService().saveNotification(title, body);
    _loadNotifications(); // Reload the notifications list
  }

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // You can show notifications here if needed for background
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return ListTile(
                  title: Text(notification['title'] ?? 'No Title'),
                  subtitle: Text(notification['body'] ?? 'No Content'),
                  trailing: Text(notification['timestamp'] ?? ''),
                );
              },
            ),


      /*body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call the showNotification method when the button is pressed
            NotificationService()
                .showNotification(title: 'Notification Title', body: 'Notification Body');
          },
          child: const Text('Show Notification'),
        ),
      ),*/
    );
  }
}
