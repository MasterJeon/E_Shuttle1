import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shuttle/config/firebase_options.dart';
import 'package:e_shuttle/features/auth/login_page.dart';
import 'package:e_shuttle/features/auth/signup_page.dart';
import 'package:e_shuttle/features/home/Help.dart';
import 'package:e_shuttle/features/home/changeRoute.dart';
import 'package:e_shuttle/features/home/e_tickets/scanPay.dart';
import 'package:e_shuttle/features/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/features/home/home.dart';
import 'package:e_shuttle/features/home/myProfile/appSettings.dart';
import 'package:e_shuttle/features/home/myProfile/profile.dart';
import 'package:e_shuttle/features/home/myWallet/eWallet.dart';
import 'package:e_shuttle/features/onboarding/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/signupPage': (_) => SignUp(),
        '/loginPage': (_) => Login(),
        '/homePage': (_) => const HomePage(),
        '/profilePage': (_) => Profile(),
        '/wallet': (_) => EWallet(),
        '/tickets': (_) => scanPay(),
        '/feedbacks': (_) => Feedbacks(),
        '/appSettings': (_) => AppSettings(),
        '/helpCenter': (_) => Help_support(),
        '/changeRoute': (_) => changeRoute(),
      },
    );
  }
}