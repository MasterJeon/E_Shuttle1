import 'package:flutter/material.dart';
import 'package:e_shuttle/services/notifi_service.dart'; // Import your notification service

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call the showNotification method when the button is pressed
            NotificationService()
                .showNotification(title: 'Notification Title', body: 'Notification Body');
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}
