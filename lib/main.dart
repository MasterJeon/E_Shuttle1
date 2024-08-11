import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shuttle/firebase_options.dart';
import 'package:e_shuttle/home/Help.dart';
import 'package:e_shuttle/home/changeRoute.dart';
import 'package:e_shuttle/home/myProfile/appSettings.dart';
import 'package:e_shuttle/home/myWallet/eWallet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_shuttle/home/SOS/SOS.dart';
import 'package:e_shuttle/home/eTickets/tickets.dart';
import 'package:e_shuttle/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/home/home.dart';
import 'package:e_shuttle/home/myProfile/profile.dart';
import 'package:e_shuttle/home/myWallet/wallet.dart';
import 'package:e_shuttle/welcome_pages/onboarding.dart';
import 'package:e_shuttle/welcome_pages/splash_screen.dart';
import 'package:e_shuttle/home/home.dart';
import 'package:e_shuttle/home/eTickets/scanPay.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth




Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      home: AuthWrapper(),  // Use AuthWrapper as the home widget
      routes: {
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/profilePage': (context) => Profile(),
        '/wallet': (context) => EWallet(),
        '/tickets': (context) => scanPay(),
        '/sos': (context) => SOS(),
        '/feedbacks': (context) => Feedbacks(),
        '/appSettings': (context) => AppSettings(),
        '/helpCenter': (context) => Help_support(),
        '/routeChange': (context) => changeRoute(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    // Return a FutureBuilder to wait for Firebase initialization
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // If Firebase is still initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(); // Display splash screen while initializing
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error initializing Firebase'));
        }

        // If user is logged in, navigate to HomePage; otherwise, navigate to LoginPage
        if (user != null) {
          return HomePage();
        } else {
          return SplashScreen();
        }
      },
    );
  }
  Future<void> _initializeApp() async {
    // Initialize Firebase and any other necessary setup
    await Firebase.initializeApp();
  }
}

//class SplashScreen extends StatelessWidget {
  //final Widget child;
  //SplashScreen({required this.child});

  //@override
  //Widget build(BuildContext context) {
  //  // You can display a loading indicator or any splash animation here
   // return Scaffold(
   //   body: FutureBuilder(
    //    // Add a small delay to show the splash screen for a bit
     //   future: Future.delayed(Duration(seconds: 2)),
      //  builder: (context, snapshot) {
        //  if (snapshot.connectionState == ConnectionState.done) {
       //     return child; // Navigate to the wrapped widget (either HomePage or LoginPage)
        //  } else {
       //     return Center(child: CircularProgressIndicator());
       //   }
       // },
     // ),
   // );
 // }
//}