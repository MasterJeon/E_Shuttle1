import 'package:e_shuttle/main.dart';
import 'package:e_shuttle/welcome_pages/wScreen1.dart';
import 'package:e_shuttle/welcome_pages/wScreen2.dart';
import 'package:e_shuttle/welcome_pages/wScreen3.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnBoardingScreen(title: 'E-Shuttle Onboarding'),
    );
  }
}


class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen ({super.key, required this.title});

  final String title;
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>{

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          Screen1(),
          Screen2(),
          Screen3(),

        ],
      )
    );
  }
}