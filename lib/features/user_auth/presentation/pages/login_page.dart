import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:e_shuttle/features/user_auth/presentation/pages/forgotPW.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:e_shuttle/global/common/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import your pages
import 'package:e_shuttle/home/Help.dart';
import 'package:e_shuttle/home/changeRoute.dart';
import 'package:e_shuttle/home/myProfile/appSettings.dart';
import 'package:e_shuttle/home/myWallet/eWallet.dart';
import 'package:e_shuttle/home/SOS/SOS.dart';
import 'package:e_shuttle/home/eTickets/tickets.dart';
import 'package:e_shuttle/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/home/home.dart';
import 'package:e_shuttle/home/myProfile/profile.dart';
import 'package:e_shuttle/home/myWallet/wallet.dart';
import 'package:e_shuttle/welcome_pages/onboarding.dart';
import 'package:e_shuttle/welcome_pages/splash_screen.dart';
import 'package:e_shuttle/welcome_pages/wScreen1.dart';
import 'package:e_shuttle/welcome_pages/welcomeScreen.dart';
import 'package:e_shuttle/welcome_pages/wScreen2.dart';
import 'package:e_shuttle/welcome_pages/wScreen3.dart';
import 'package:e_shuttle/home/eTickets/scanPay.dart';
//import 'package:e_shuttle/features/user_auth/presentation/pages/home_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:e_shuttle/firebase_options.dart';
import 'package:e_shuttle/startupPages/selectRoute.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Exit the app if back button is pressed
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets. symmetric(vertical: 30),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(255, 230, 81, 0),
                    const Color.fromRGBO(239, 108, 0, 1),
                    const Color.fromRGBO(255, 167, 38, 1)
                  ],
              )
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),),
                    SizedBox(height: 10,),
                    Text("It's nice to see you again!", style: TextStyle(color: Colors.white, fontSize: 18),),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  height: double.infinity,
                  width: double.infinity,

                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: SingleChildScrollView( //length of the box
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 50,),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),

                          //the Email & password decos
                          child: Column(
                            children: <Widget>[
                              FormContainerWidget(
                                controller: _emailController,
                                hintText: "Email",
                                isPasswordField: false,
                              ),
                              FormContainerWidget(
                                controller: _passwordController,
                                hintText: "Password",
                                isPasswordField: true,
                              ),
                            ],
                          ),
                        ),

                         SizedBox(height: 30,),

                       // Wrap "Forgot Password?" with GestureDetector
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                        SizedBox(height: 50,),

                        GestureDetector(
                          onTap: () {
                            _signIn();
                          },
                          child: Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(0, 69, 230, 1),
                                    Color.fromRGBO(0, 115, 239, 1),
                                    Color.fromRGBO(38, 201, 255, 1)
                                  ]
                              ),
                            ),
                            child: Center(
                              child: _isSigning ? CircularProgressIndicator(
                                color: Colors.white,) : Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),

                        SizedBox(height: 35,),
                        Text("Don't have an account?", style: TextStyle(color: Colors.grey),),

                        SizedBox(height: 30,),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                                  (route) => false,
                            );
                          },
                          child: Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(230, 81, 0, 1),
                                    Color.fromRGBO(239, 108, 0, 1),
                                    Color.fromRGBO(255, 167, 38, 1)
                                  ]

                              ),
                            ),
                            child: Center(
                              child: _isSigning ? CircularProgressIndicator(
                                color: Colors.white,) : Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),);
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        await _updatePasswordInFirestore(user.uid, password);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showToast(message: "Email or Password incorrect");
      }
    } catch (e) {
      showToast(message: "Error: ${e.toString()}");
    }
  }

  Future<void> _updatePasswordInFirestore(String uid, String newPassword) async {
    // Reference to the Firestore collection
    CollectionReference passengers = FirebaseFirestore.instance.collection('passenger');

    // Fetch the user's document by UID
    DocumentSnapshot snapshot = await passengers.doc(uid).get();

    if (snapshot.exists) {
      // Extract the existing password and password_confirm from Firestore
      String existingPassword = snapshot.get('password');
      String existingPasswordConfirm = snapshot.get('password_confirm');

      // Compare the new password with the existing one
      if (newPassword != existingPassword || newPassword != existingPasswordConfirm) {
        // If the passwords don't match, update them
        await passengers.doc(uid).update({
          'password': newPassword,
          'password_confirm': newPassword
        });

        showToast(message: "Password updated successfully.");
      } else {
        showToast(message: "Password is already up-to-date.");
      }
    } else {
      showToast(message: "User not found in database.");
    }
  }

  _signInWithGoogle()async{

    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushNamed(context, "/home");
      }

    }catch(e) {
      showToast(message: "some error occured $e");
    }

  }

}