import 'package:e_shuttle/welcome_pages/onboarding.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ),
);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background and content
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 115, 239, 0.884),
                  Color.fromRGBO(22, 5, 107, 0.94),
                  Color.fromRGBO(8, 1, 41, 0.94),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.05,
                horizontal: screenSize.width * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  SizedBox(
                    width: 700,
                    height: 300,
                    child: Image.asset('assets/welcome.png'), // Replace with your image asset path
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Welcome to E-Shuttle!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Commute to KDU effortlessly! Track buses, buy digital tickets, and travel safe — all in one app. Your smarter, faster way to travel. Let's get started!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 100),
                  buildButtons(),
                ],
              ),
            ),
          ),
          // KDU logo in the top-left corner
          Positioned(
            top: 35,
            left: 20,
            child: Image.asset(
              'assets/kdu_logo.png', // Replace with the actual path of your KDU logo
              height: 50,
              width: 50,
            ),
          ),
          // E-Shuttle logo in the top-right corner
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/logo.png', // Replace with the actual path of your E-Shuttle logo
              height: 110,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OnBoardingScreen(title: 'E-Shuttle Onboarding'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(230, 81, 0, 1),
              Color.fromRGBO(239, 108, 0, 1),
              Color.fromRGBO(255, 167, 38, 1),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}



