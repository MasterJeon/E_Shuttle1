import 'package:e_shuttle/home/myWallet/eWallet.dart';
import 'package:e_shuttle/home/myWallet/recharge.dart';
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
  String qrData = "google"; // Data set from the backend

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
                      child: QrImageView(
                        data: 'hi Dharani madam', // this must be a randomly generated code if else user can also generate the code himself
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor:  Colors.white,
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
