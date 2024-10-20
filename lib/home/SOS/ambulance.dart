import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

void main() {
  runApp( AmbulancePageApp());
}

class AmbulancePageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AmbulancePage(),
    );
  }
}

class AmbulancePage extends StatelessWidget {
  final List<Map<String, String>> ambulanceServices = [
    {
      'name': 'Suwa Sariya',
      'phone': '1990',
      'icon': 'assets/suwa_sariya.png', // Replace with your ambulance icon
    },
    {
      'name': 'Sri Lanka Red Cross Society',
      'phone': '0112421111',
      'icon': 'assets/red_cross.png', // Replace with your ambulance icon
    },
    {
      'name': 'Mediquick Ambulance Service',
      'phone': '0112695411',
      'icon': 'assets/mediquick.png', // Replace with your ambulance icon
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambulance Service Contacts'),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Adjust to your theme color
      ),
      body: ListView.builder(
        itemCount: ambulanceServices.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(ambulanceServices[index]['icon']!),
                radius: 30,
              ),
              title: Text(
                ambulanceServices[index]['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 5),
                  Text(ambulanceServices[index]['phone']!),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _callAmbulance(ambulanceServices[index]['phone']!);
                },
                child: Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _callAmbulance(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
