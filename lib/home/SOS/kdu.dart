import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:e_shuttle/home/SOS/SOS.dart';

void main() {
  runApp(KDU());
}

class KDU extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: ProfileTab(),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final List<Map<String, String>> hotlines = [
    {'name': 'Hotline 1', 'phone': '011-2635268'},
    {'name': 'Hotline 2', 'phone': '011-2638656'},
    {'name': 'Motor Transport Section', 'phone': '011-2638657'},
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SOS()),
            );
          },
        ),
        title: Text('Inform KDU'),
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/kdu_logo.png'),
            ),
            SizedBox(height: 16),
            Text(
              'GENERAL SIR JOHN KOTELAWALA\nDEFENCE UNIVERSITY',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ...hotlines.map((hotline) => hotlineBox(context, hotline)).toList(),
          ],
        ),
      ),
    );
  }

  Widget hotlineBox(BuildContext context, Map<String, String> hotline) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 55, 111, 179),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Call Icon
          Icon(
            Icons.call,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(width: 16),
          // Hotline Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotline['name']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  hotline['phone']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Call Button
          ElevatedButton(
            onPressed: () => _callHotline(hotline['phone']!),
            child: Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _callHotline(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}