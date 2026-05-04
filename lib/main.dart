import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shuttle/config/firebase_options.dart';
import 'package:e_shuttle/features/home/Help.dart';
import 'package:e_shuttle/features/home/changeRoute.dart';
import 'package:e_shuttle/features/home/myProfile/appSettings.dart';
import 'package:e_shuttle/features/home/myWallet/eWallet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_shuttle/features/home/SOS/SOS.dart';
import 'package:e_shuttle/features/home/e_tickets/tickets.dart';
import 'package:e_shuttle/features/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/features/home/home.dart';
import 'package:e_shuttle/features/home/myProfile/profile.dart';
import 'package:e_shuttle/features/home/myWallet/wallet.dart';
import 'package:e_shuttle/features/auth/login_page.dart';
import 'package:e_shuttle/features/auth/signup_page.dart';

import 'package:e_shuttle/features/onboarding/onboarding.dart';
import 'package:e_shuttle/features/onboarding/splash_screen.dart';
import 'package:e_shuttle/features/onboarding/wScreen1.dart';
import 'package:e_shuttle/features/onboarding/welcomeScreen.dart';
import 'package:e_shuttle/features/onboarding/wScreen2.dart';
import 'package:e_shuttle/features/onboarding/wScreen3.dart';

import 'package:e_shuttle/features/home/e_tickets/scanPay.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  //const MyApp({super.key});

  //State<MyApp> createState() => _MyAppState();  
//}

//class _MyAppState extends State<MyApp>{

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      
      routes: { 
        '/':(context) => SplashScreen(),
        '/signupPage':(context) => SignUp(),
         '/loginPage':(context) => Login(),
          '/homePage':(context) => HomePage(),
          '/profilePage':(context) => Profile(),
          '/wallet':(context) => EWallet(),
          '/tickets':(context) => scanPay(),
          //'/sos':(context) => SOS(),
          '/feedbacks':(context) => Feedbacks(),
          //'/tickets':(context) => Tickets(),
          '/appSettings':(context) => AppSettings(),
          '/helpCenter':(context) => Help_support(),
          '/routeChnge':(context) => changeRoute()
      },
    );
  }
}