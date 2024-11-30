import 'package:flutter/material.dart';

void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountVerification(),
    )
);

class AccountVerification extends StatefulWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  AccountVerificationState createState() => AccountVerificationState();
}

class AccountVerificationState extends State<AccountVerification> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  


  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Set padding relative to screen size
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.03,
              horizontal: screenSize.width * 0.08,
            ),
          ),
        ),
      ),
    );
  }
}
