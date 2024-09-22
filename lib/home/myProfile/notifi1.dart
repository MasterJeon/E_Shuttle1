import 'package:e_shuttle/services/notifi_service.dart';
import 'package:flutter/material.dart';

class Notifi_1 extends StatefulWidget {
  const Notifi_1({super.key, required this.title});

  final String title;

  @override
  State<Notifi_1> createState() => _Notifi_1State();
}

class _Notifi_1State extends State<Notifi_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text('Show notifications'),
        onPressed: () {
          NotificationService()
              .showNotification(title: 'Sample title', body: 'It works!');
        },
      )),
    );
  }
}