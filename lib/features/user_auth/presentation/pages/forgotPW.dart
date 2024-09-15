import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_auth/email_auth.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ForgotPasswordPage(),
  ));
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  EmailAuth emailAuth =  new EmailAuth(sessionName: "Sample session");
  //late EmailAuth emailAuth;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();

  String getOtp() {
    // Concatenating the values from each OTP controller to form the full OTP
    return _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text +
        _otpController5.text +
        _otpController6.text;
  }

  void initState() {
    super.initState();
    //emailAuth = EmailAuth(sessionName: "eShuttle Password Reset");
  }

  void sendOtp() async {
    try {
      bool result = await emailAuth.sendOtp(recipientMail: _emailController.value.text, otpLength: 6);
      if (result) {
        print("OTP sent successfully to: ${_emailController.text}");
      } else {
        print("Failed to send OTP.");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  void verifyOtp() async {
    String otp = getOtp();
    bool isVerified = emailAuth.validateOtp(
      recipientMail: _emailController.value.text, // Use 'recipient' instead of 'receiverMail'
      userOtp: otp,
    );
    if (isVerified) {
      print("OTP verification successful!");
      // Navigate to password reset screen
    } else {
      print("OTP verification failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.05,
            horizontal: screenSize.width * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Text
              const SizedBox(height: 40),
              const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle Text
              const Text(
                "No worries, we'll send you reset instructions.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button with Gradient
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 69, 230, 1),
                      Color.fromRGBO(0, 115, 239, 1),
                      Color.fromRGBO(38, 201, 255, 1)
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: sendOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // OTP Input
              const Text(
                "Please enter the 6-digit OTP code you received on your email address to reset the password.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  otpTextField(controller: _otpController1, first: true, last: false),
                  otpTextField(controller: _otpController2, first: false, last: false),
                  otpTextField(controller: _otpController3, first: false, last: false),
                  otpTextField(controller: _otpController4, first: false, last: false),
                  otpTextField(controller: _otpController5, first: false, last: false),
                  otpTextField(controller: _otpController6, first: false, last: true),
                ],
              ),
              const SizedBox(height: 40),

              // Reset Password Button with Gradient
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 69, 230, 1),
                      Color.fromRGBO(0, 115, 239, 1),
                      Color.fromRGBO(38, 201, 255, 1)
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    String otp = getOtp();
                    print("Entered OTP: $otp");
                    print("Reset password link sent to: ${_emailController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),





              const SizedBox(height: 40),

              // Resend OTP
                RichText(
                  text: TextSpan(
                    text: "Didn't receive the Email? ",
                    style: const TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black, // Black color for this part
                    ),
                    children: [
                      TextSpan(
                        text: 'Send Again',
                        style: const TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                          color: Colors.blue, // Blue color for 'Send Again'
                          decoration: TextDecoration.underline, // Underlined
                        ),
                        /*recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add your logic here to resend the OTP/email
                            print("Resending OTP to: ${_emailController.text}");
                          },*/
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 18),

              // Back to log in
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Back to log in",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // OTP TextField Helper
  Widget otpTextField({
    required TextEditingController controller,
    required bool first,
    required bool last,
  }) {
    return SizedBox(
      height: 60,
      width: 45,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1 && !last) {
            FocusScope.of(context).nextFocus();
          } else if (value.length == 0 && !first) {
            FocusScope.of(context).previousFocus();
          }
        },
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
