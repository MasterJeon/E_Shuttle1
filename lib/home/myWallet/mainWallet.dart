import 'package:e_shuttle/home/myWallet/recharge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51PmYqFRwXCT02Fy3WC6V7Im7d8tkcQiLMK4j6Mu4QZucBoh4PlxXFRYxrEbR8azb9Fmki5hoAcOhz9qXwz7hmMHC00IHQtcaab";
  runApp(const Mainwallet());
}

class Mainwallet extends StatelessWidget {
  const Mainwallet({Key? key}) : super(key: key);

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RechargePage(),
    );
  }
}
