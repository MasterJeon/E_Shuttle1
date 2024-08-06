import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String qrData = "google"; // Data set from the backend

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Generator"),
      ),
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
                      child: QrImageView(
                        data: 'Hello Sumuduu', // this must be a randomly generated code if else user can also generate the code himself
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
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
          child: ElevatedButton(
            onPressed: () {
              // Handle QR code scanner button press
            },
            child: Text('Check Balance'),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle payment button press
            },
            child: Text('Recharge'),
          ),
        ),
      ],
    );
  }
}
