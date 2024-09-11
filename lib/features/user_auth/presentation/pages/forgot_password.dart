import 'package:e_shuttle/features/user_auth/presentation/pages/forgot_password1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordPage(),
    ),
  );
}

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.05,
              horizontal: screenSize.width * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                'assets/Forgot pw.png',
                ),
                SizedBox(height: 30),

                // Title Text
                Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Subtitle Text
                Text(
                  "No worries, we'll send you reset instructions.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Email TextField
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Reset Password Button
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                       // Navigate to forgotPW_OTP page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => forgotPW_OTP(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Use backgroundColor instead of primary
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16), // Example padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Customize shape
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  )
                ),
                SizedBox(height: 24),

                // Back to log in with GestureDetector for navigation
                GestureDetector(
                  onTap: () {
                    // Handle back to login navigation
                    Navigator.pop(context); // Assuming the previous page is login
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Back to log in",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
