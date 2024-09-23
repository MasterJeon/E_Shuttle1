import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer = Timer.periodic(
        const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email Successfully Verified")));

      timer?.cancel();
      Navigator.pushReplacementNamed(context, "/selectRoute");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize userEmail to fetch the current user's email
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Placeholder for the image at the top
                Image.asset(
                  'assets/emailVeri.png',
                ),

                const SizedBox(height: 20),

                const Text(
                  'Verify your Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'An email has been sent to your email address ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 26, 26, 26),
                    ),
                    children: [
                      TextSpan(
                        text: userEmail, // This will be bold now
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text:
                            '. Please click on the link to verify your email.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Confirm email button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Confirm email'),
                  onPressed: () {
                    checkEmailVerified();
                  },
                ),

                const SizedBox(height: 35),

                const Text(
                  "Didn't receive the email?",
                  style: TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 10),

                // Resend email button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Resend'),
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Verification email resent.")));
                  },
                ),

                const SizedBox(height: 30),

                const Center(child: CircularProgressIndicator()),

                const SizedBox(height: 8),

                const Text(
                  'Verifying email....',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
