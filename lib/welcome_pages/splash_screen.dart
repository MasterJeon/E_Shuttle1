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

class SplashScreen extends StatefulWidget{
  const SplashScreen ({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
with SingleTickerProviderStateMixin{

  void initState(){
    super.initState();
    SystemChrome. setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 6),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
        ));
    });
  }

  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
     overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[
              Color.fromRGBO(0, 115, 239, 0.884),
              Color.fromRGBO(22, 5, 107, 0.94),      
              Color.fromRGBO(8,1, 41, 0.94),
               Color.fromRGBO(239, 108, 0, 1),
              //const Color.fromRGBO(255, 167, 38, 1),
             // Color.fromRGBO(12,2, 59, 0.94),
              //Color.fromRGBO(0, 90, 150, 0.94),
              //Color.fromRGBO(12,2, 59, 0.94),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
       child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height:400,
              width:400,
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
    );
  }
}
