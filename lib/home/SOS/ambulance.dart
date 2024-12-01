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
      //theme: ThemeData(
        //primarySwatch: Colors.indigo,
      //),
      home: AmbulancePage(),
    );
  }
}

class AmbulancePage extends StatelessWidget {
  final List<Map<String, String>> ambulanceServices = [
    {
      'name': 'Suwa Sariya',
      'phone': '0771254183',
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
        ), // Adjust to your theme color
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
                  backgroundColor: const Color.fromARGB(255, 80, 139, 240),
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
