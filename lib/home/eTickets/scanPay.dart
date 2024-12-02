import 'package:e_shuttle/home/myWallet/eWallet.dart';
import 'package:e_shuttle/home/myWallet/recharge.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase auth to get the current user ID

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: scanPay(),
    );
  }
}

class scanPay extends StatefulWidget {
  const scanPay({super.key});

  @override
  State<scanPay> createState() => _scanPayState();
}

class _scanPayState extends State<scanPay> {
  String? qrData;

  void initState() {
    super.initState();
    generateAndSaveQrCode();
  }

  void generateAndSaveQrCode() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? "unknown_user";
    String generatedQrData = "QR_${DateTime.now().millisecondsSinceEpoch}_$userId";

    await FirebaseFirestore.instance.collection('passenger_qr_codes').doc(userId).set({
      'qr_code': generatedQrData,
      'status': 'unused',
      'timestamp': FieldValue.serverTimestamp(),
      'scanned_by': 'unknown',
    });

    setState(() {
      qrData = generatedQrData;
    });
  }

  Future<void> updateQrCodeStatus(String scannedData) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? "unknown_user";

    DocumentSnapshot driverDoc = await FirebaseFirestore.instance.collection('driver').doc(userId).get();
    String driverRole = driverDoc.get('role');

    if (driverRole == 'driver') {
      await FirebaseFirestore.instance.collection('passenger_qr_codes').doc(userId).update({
        'status': 'scanned',
        'scanned_by': userId,
        'scanned_time': FieldValue.serverTimestamp(),
      });

      generateAndSaveQrCode();
    } else {
      print("You do not have permission to scan this QR code.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(0, 69, 230, 1),
              Color.fromRGBO(0, 115, 239, 1),
              Color.fromRGBO(38, 201, 255, 1),
            ],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 90),
            Text(
              'E-Tickets',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Scan to Pay...!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Validate your code at the bus entrance before and after your arrival to exit.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: qrData != null
                            ? QrImageView(
                                data: qrData!,
                                version: QrVersions.auto,
                                size: 200.0,
                                backgroundColor: Colors.white,
                              )
                            : CircularProgressIndicator(),
                      ),
                      SizedBox(height: 40),
                      buildButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EWallet()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
              Color.fromARGB(255, 230, 81, 0),
              const Color.fromRGBO(239, 108, 0, 1),
              const Color.fromRGBO(255, 167, 38, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Check Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RechargePage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
              Color.fromARGB(255, 230, 81, 0),
              const Color.fromRGBO(239, 108, 0, 1),
              const Color.fromRGBO(255, 167, 38, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Recharge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
