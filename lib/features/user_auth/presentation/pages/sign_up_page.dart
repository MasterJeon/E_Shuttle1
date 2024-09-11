import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_shuttle/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:e_shuttle/global/common/toast.dart';
import 'package:e_shuttle/services/database_service.dart';
import 'package:e_shuttle/models/userRegistration.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:e_shuttle/features/user_auth/presentation/pages/home_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:e_shuttle/firebase_options.dart';
import 'package:e_shuttle/startupPages/selectRoute.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _registrationNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNoController = TextEditingController();
  TextEditingController _guardianContactNoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _registrationNoController.dispose();
    _addressController.dispose();
    _contactNoController.dispose();
    _guardianContactNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, //this will prevent the keyboar ftom coveing the content
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(230, 81, 0, 1),
                  Color.fromRGBO(239, 108, 0, 1),
                  Color.fromRGBO(255, 167, 38, 1)
                ]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Create Your\nAccount',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,

                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _fullNameController,
                        hintText: "",
                        labelText: "Full Name",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _registrationNoController,
                        hintText: "",
                        labelText: "Registration No. (Staff/Student)",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _emailController,
                        hintText: "",
                        labelText: "Email",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _addressController,
                        hintText: "",
                        labelText: "Address",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _contactNoController,
                        hintText: "",
                        labelText: "Contact No.",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _guardianContactNoController,
                        hintText: "",
                        labelText: "Guardian's Contact No.",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormContainerWidget(
                        controller: _passwordController,
                        hintText: "",
                        labelText: "Password",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 13,
                      ),

                      FormContainerWidget(
                        controller: _confirmPasswordController,
                        hintText: "",
                        labelText: "Confirm Password",
                        // Label text that will float above when typing
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 25,
                      ),

                    
                      GestureDetector(
                        onTap: () {
                          _signUp();
                        },
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(0, 69, 230, 1),
                              Color.fromRGBO(0, 115, 239, 1),
                              Color.fromRGBO(38, 201, 255, 1)
                            ]),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
          ],
        ),

      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text;
    String fullName = _fullNameController.text;
    String registrationNo = _registrationNoController.text;
    String address = _addressController.text;
    String contactNo = _contactNoController.text;
    String guardianContactNo = _guardianContactNoController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      showToast(message: "Passwords do not match!");
      setState(() {
        isSigningUp = false;
      });
      return;
    }

    try {
      // Step 1: Create a new user with Firebase Authentication
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        // Step 2: Prepare the data to be saved to Firestore
        UserRegistration userRegistration = UserRegistration(
          student_id: registrationNo,
          password: password,
          password_confirm: confirmPassword,
          contact_no: contactNo,
          email: email,
          full_name: fullName,
          guardian_contact_no: guardianContactNo,
          wallet_balance: 0.0, // Initialize wallet balance
          routeno: ' ', //Initialize route no
        );

        // Step 3: Save the user data to Firestore
        await registerService.setWithId(user.uid, userRegistration);

        // Step 4: Create subcollections with empty attributes
        final refundRequestRef = registerService.firestore
            .collection(COLLECTION_REF_REGISTER)
            .doc(user.uid)
            .collection('refund_requests');

        final boughtTicketsRef = registerService.firestore
            .collection(COLLECTION_REF_REGISTER)
            .doc(user.uid)
            .collection('bought_tickets');

        // Add empty documents with the specified fields
        await refundRequestRef.add({
          'amount': '',
          'date': '',
          'route': '',
          'stop': '',
          'reason': '',
        });

        await boughtTicketsRef.add({
          'amount': '',
          'stop_no': '',
          'stop': '',
          'time_date': '',
        });

        // Notify user of success and navigate to login
        showToast(message: "User successfully created");
        Navigator.pushNamed(context, "/selectRoute");
      } else {
        showToast(message: "An error occurred during sign-up.");
      }
    } catch (e) {
      // Handle any errors
      showToast(message: "Error: ${e.toString()}");
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }
}

