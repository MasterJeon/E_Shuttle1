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
  //final GlobalKey globalKey = GlobalKey();
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
            RepaintBoundary(
              //key: globalKey,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.03,
                  horizontal: screenSize.width * 0.08,
                ),
                color: Colors.grey,
                child: Center(
                  child: QrImageView(
                    data: 'I love u',//this must be a randomly generated code if else user can also generate the code himself
                    version: QrVersions.auto,
                    size: 200.0,
                    //gapless: false,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
