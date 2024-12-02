import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:e_shuttle/services/notifi_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  List<DocumentSnapshot> _notifications = []; // Store notifications from Firestore

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _configureFCM();
    _fetchNotifications();
  }

  // Request Notification Permission
  void _requestNotificationPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Configure Firebase Cloud Messaging
  void _configureFCM() {
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      NotificationService().showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      _fetchNotifications(); // Reload notifications
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
    });
  }

  Future<void> _fetchNotifications() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final userEmail = currentUser.email;

      String role = '';
      String userRoute = '';

      print('Current user email: $userEmail');

      // Check role and route
      final driverDoc = await _firestore
          .collection('driver')
          .where('email', isEqualTo: userEmail)
          .get();

      final passengerDoc = await _firestore
          .collection('passenger')
          .where('email', isEqualTo: userEmail)
          .get();

      if (driverDoc.docs.isNotEmpty) {
        role = 'driver';
        userRoute = driverDoc.docs.first['routeno'];
        print('User is a Driver on route: $userRoute');
      } else if (passengerDoc.docs.isNotEmpty) {
        role = 'passenger';
        userRoute = passengerDoc.docs.first['routeno'];
        print('User is a Passenger on route: $userRoute');
      } else {
        print('User not found in drivers or passengers collection.');
        return;
      }

      if (role.isNotEmpty && userRoute.isNotEmpty) {
        final now = DateTime.now();

        // Fetch notifications
        final notificationsQuery = await _firestore
            .collection('notifications')
            .where('recipient', isEqualTo: role)
            .where('routeno', isEqualTo: userRoute)
            .get();

        print('Fetched notifications count: ${notificationsQuery.docs.length}');

        final unseenNotifications = notificationsQuery.docs.where((doc) {
          try {
            // Debug: Log notification data
            print('Processing notification: ${doc.data()}');

            // Safeguard for seenBy field
            final seenBy = (doc['seenby'] is List)
                ? List<String>.from(doc['seenby'])
                : []; // Handle null or invalid seenBy field

            // Debug: Log seenBy details
            print('Notification ${doc.id} seenBy: $seenBy, userEmail: $userEmail');

            // Safeguard for timestamp field
            final timestampStr = doc['timestamp'];
            if (timestampStr == null) {
              print('Missing timestamp for notification ${doc.id}');
              return false;
            }

            DateTime? timestamp;
            try {
              timestamp = DateTime.parse(timestampStr);
            } catch (e) {
              print('Invalid timestamp format for notification ${doc.id}: $e');
              return false;
            }

            final now = DateTime.now();

            // Check conditions
            final isWithinTime =
                timestamp.isAfter(now.subtract(Duration(hours: 48))) &&
                    timestamp.isBefore(now);
            print('Notification ${doc.id} isWithinTime: $isWithinTime');

            final isUnseen = !seenBy.any((email) => email.toLowerCase() == userEmail!.toLowerCase());
            print('Notification ${doc.id} isUnseen: $isUnseen');

            return isWithinTime && isUnseen;
          } catch (e) {
            print('Error processing notification ${doc.id}: $e');
            return false;
          }
        }).toList();

        setState(() {
          _notifications = unseenNotifications;
        });

        print('Notifications to display: ${_notifications.length}');
      }
    }
  }







  Future<void> _markNotificationAsSeen(String docId) async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final userEmail = currentUser.email;

      // Update Firestore to add the user's email to the "seenBy" array
      await _firestore.collection('notifications').doc(docId).update({
        'seenby': FieldValue.arrayUnion([userEmail]),
      });

      // Refresh notifications
      _fetchNotifications();
    }
  }

  // Dismiss Notification
  Future<void> _dismissNotification(String docId) async {
    await _firestore.collection('notifications').doc(docId).delete();
    _fetchNotifications(); // Refresh the notifications list
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
            final title = notification['notification'] ?? 'No Title';
            final timestampStr = notification['timestamp'];
            String formattedTimestamp = 'Unknown Time';

            // Parse and format timestamp
            try {
              final timestamp = DateTime.parse(timestampStr);
              formattedTimestamp =
              "${timestamp.hour}:${timestamp.minute}, ${timestamp.day}/${timestamp.month}/${timestamp.year}";
            } catch (e) {
              print('Error parsing timestamp for notification ${notification.id}: $e');
            }

            return Dismissible(
              key: Key(notification.id),
              onDismissed: (direction) {
                _markNotificationAsSeen(notification.id); // Mark notification as seen
                setState(() {
                  _notifications.removeAt(index); // Remove locally
                });
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(title),
                subtitle: Text(formattedTimestamp),
              ),
            );
          }
      ),
    );
  }
}
