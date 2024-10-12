import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:e_shuttle/features/user_auth/presentation/pages/forgotPW.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/forgot_password.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/forgot_password1.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/forgot_password2.dart';
import 'package:e_shuttle/firebase_options.dart';
import 'package:e_shuttle/home/Help.dart';
import 'package:e_shuttle/home/changeRoute.dart';
import 'package:e_shuttle/home/find_shuttle.dart';
import 'package:e_shuttle/home/myProfile/appSettings.dart';
import 'package:e_shuttle/home/myProfile/notifi.dart';
import 'package:e_shuttle/home/myProfile/shareLiveLocation.dart';
import 'package:e_shuttle/home/myProfile/trustedContacts.dart';
import 'package:e_shuttle/home/myWallet/eWallet.dart';
import 'package:e_shuttle/services/notifi_service.dart';
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
import 'package:e_shuttle/home/eTickets/scanPay.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:e_shuttle/home/myWallet/recharge.dart';
import 'package:e_shuttle/home/myWallet/refund.dart';
import 'package:e_shuttle/home/myProfile/myInformation.dart';
import 'package:e_shuttle/home/routemap.dart';
import 'package:e_shuttle/testingMap/livelocation.dart';
import 'package:e_shuttle/testingMap/routetest.dart';
import 'package:e_shuttle/startupPages/selectRoute.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/email_verification_page.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  Stripe.publishableKey = "pk_test_51PmYqFRwXCT02Fy3WC6V7Im7d8tkcQiLMK4j6Mu4QZucBoh4PlxXFRYxrEbR8azb9Fmki5hoAcOhz9qXwz7hmMHC00IHQtcaab"; // Initialize Stripe with your publishable key
  runApp(MyApp());
  await Firebase.initializeApp();

  NotificationService().initNotification(); //initialize the notification service
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
        '/forgotPassword':(context) => ForgotPasswordPage(),
        //'/forgotPasswordOTP':(context) => forgotPW_OTP(),
        //'/forgotPasswordReset':(context) => forgotPW_Reset(),
        //'/forgotPasswordPageNew':(context) => ForgotPasswordPage(),
        '/home': (context) => HomePage(),

        //'/signupPage':(context) => SignUp(),
        //'/loginPage':(context) => Login(),
        //'/homePage':(context) => HomePage(),
        '/profilePage':(context) => Profile(),
        '/wallet':(context) => EWallet(),
        '/recharge': (context) => RechargePage(),
        '/refund': (context) => RefundPage(),
        '/tickets':(context) => scanPay(),
        '/sos':(context) => SOS(),
        '/feedbacks':(context) => Feedbacks(),
        '/myinformation':(context) => MyInformation(),
        '/shareLocation':(context) => ShareLiveLocationPage(),
        '/TrustedContacts':(context) => TrustedContactsPage(),
        //'/tickets':(context) => Tickets(),
        '/appSettings':(context) => AppSettings(),
        '/notificationpage':(context) => NotificationsPage(),
        '/helpCenter':(context) => Help_support(),
        '/routeChange':(context) => ChangeRoute(),
        'routemap':(context) => RouteMapPage(),
        '/livelocation':(context) => LiveLocation(),
        '/routetest':(context) => MyRoute(),
        '/selectRoute':(context) => SelectRoute(),
        '/findShuttle':(context) => ShuttleDetailsPage(),
        '/emailVerification':(context) => EmailVerificationScreen(),
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


