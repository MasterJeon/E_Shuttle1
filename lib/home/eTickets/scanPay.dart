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
  String? qrData; // Data fetched from Firestore (initially null)

  void initState() {
    super.initState();
    generateAndSaveQrCode(); // Call method to generate QR code
  }

  // Method to generate a random QR code and save it to Firestore
  void generateAndSaveQrCode() async {
    // Get the current user ID from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? "unknown_user";

    // Generate QR code data (you can customize this further)
    String generatedQrData = "QR_${DateTime.now().millisecondsSinceEpoch}_$userId";

    // Save QR code data to Firestore (under the user's document)
    await FirebaseFirestore.instance.collection('passenger_qr_codes').doc(userId).set({
      'qr_code': generatedQrData,
      'status': 'unused',
      'timestamp': FieldValue.serverTimestamp(),
      'scanned_by': 'unknown',
    });

    // Update the state to display the generated QR code
    setState(() {
      qrData = generatedQrData;
    });
  }

  // Method to update QR code status after it's scanned by the driver
  Future<void> updateQrCodeStatus(String scannedData) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? "unknown_user";
    // Get the driver’s role from Firestore (for now, let's assume a role field exists in the user profile)
    DocumentSnapshot driverDoc = await FirebaseFirestore.instance.collection('driver').doc(userId).get();
    String driverRole = driverDoc.get('role');

    // Only allow drivers to update the QR status
    if (driverRole == 'driver') {
      // Update the QR code status in Firestore to 'scanned'
      await FirebaseFirestore.instance.collection('passenger_qr_codes').doc(userId).update({
        'status': 'scanned',
        'scanned_by': userId,
        'scanned_time': FieldValue.serverTimestamp(),
      });

      // Regenerate the QR code after it's scanned
      generateAndSaveQrCode();
    } else {
      print("You do not have permission to scan this QR code.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      //appBar: AppBar(
        //title: Text("QR Code Generator"),
      //),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              'E-Tickets',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              child: Column(
                children: [
                  Text(
                    'Scan to Pay...!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Validate your code at the bus entrance before and after your arrival to exit.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 28),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.03,
                      horizontal: screenSize.width * 0.08,
                    ),
                    color: Colors.white,
                    child: Center(
                      child: qrData != null
                          ? QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              child: buildButtons(),
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
            // Handle QR code scanner button press
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(0, 69, 230, 1),
                  Color.fromRGBO(0, 115, 239, 1),
                  Color.fromRGBO(38, 201, 255, 1),
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
            // Handle payment button press
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(0, 69, 230, 1),
                  Color.fromRGBO(0, 115, 239, 1),
                  Color.fromRGBO(38, 201, 255, 1),
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
