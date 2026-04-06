import 'package:e_shuttle/welcome_pages/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  )
);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      )
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(0, 115, 239, 0.884),
              Color.fromRGBO(22, 5, 107, 0.94),
              Color.fromRGBO(8, 1, 41, 0.94),
              Color.fromRGBO(239, 108, 0, 1),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        
        child: Center(
  child: Padding(
    padding: const EdgeInsets.only(top: 10.0), // Adjust this value to move the Row higher
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row for KDU logo and university name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/kdu_logo.png',
              height: 80,
              width: 80,
            ),
            SizedBox(width: 10),
            Text(
              'General Sir John Kotelawala\nDefence University',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        // Remaining content
        Image.asset(
          'assets/logo.png',
          height: 400,
          width: 400,
        ),
        SizedBox(height: 20),
        Text(
          "E - S h u t t l e",
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Container(
          width: 200,
          height: 2,
          color: Colors.white,
        ),
        SizedBox(height: 10),
        Text(
          "Journey for Comfort",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
),

        
        
        /*child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row for KDU logo and university name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/kdu_logo.png', // Replace with the correct asset path for KDU logo
                    height: 80, // Adjust as per your logo's size
                    width: 80,
                  ),
                  SizedBox(width: 10), // Spacing between logo and text
                  Text(
                    'General Sir John Kotelawala\nDefence University',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40), // Adjusted spacing between logo and app content
              Image.asset(
                'assets/logo.png',
                height: 400,
                width: 400,
              ),
              SizedBox(height: 20),
              Text(
                "E - S h u t t l e",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 200,
                height: 2,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                "Journey for Comfort",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),*/
      ),
    );
  }
}
