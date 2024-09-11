import 'package:flutter/material.dart';
//import 'features/user_auth/presentation/pages/forgot_password1.dart'; // Import your reset password page here
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Remove the debug banner
      home: forgotPW_Reset(),  // Set ResetPasswordPage as the starting page
    );
  }
}

class forgotPW_Reset extends StatefulWidget {
  @override
  _forgotPW_ResetState createState() => _forgotPW_ResetState();
}

class _forgotPW_ResetState extends State<forgotPW_Reset> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Adjustable Reset Password Image
                SizedBox(height: 40),
                Image.asset(
                  'assets/resetPW.png', // Update with your image path
                  height: 300, // Adjustable height
                  width: 250,  // Adjustable width
                ),
                SizedBox(height: 40),
                Text(
                  'Set new password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Must be at least 8 characters.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                // Password Text Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    hintText: 'Enter new password',
                  ),
                ),
                SizedBox(height: 16),
                // Confirm Password Text Field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    border: OutlineInputBorder(),
                    hintText: 'Re-enter new password',
                  ),
                ),
                SizedBox(height: 24),
                // Reset Password Button
                ElevatedButton(
                  onPressed: () {
                    // Validate passwords
                    if (passwordController.text ==
                        confirmPasswordController.text &&
                        passwordController.text.length >= 8) {
                      // Navigate to Login Page after password reset
                      Navigator.pop(context); // Assuming the previous page is the login page
                    } else {
                      // Show error if passwords don't match or are too short
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Passwords do not match or are too short!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Reset password'),
                ),
                SizedBox(height: 24),
                // Back to Log In with GestureDetector
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/login");// Navigate back to login page
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 16, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        'Back to log in',
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
