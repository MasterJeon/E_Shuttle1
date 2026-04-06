import 'package:e_shuttle/main.dart';
import 'package:e_shuttle/startupPages/login_page.dart';
import 'package:e_shuttle/welcome_pages/wScreen1.dart';
import 'package:e_shuttle/welcome_pages/wScreen2.dart';
import 'package:e_shuttle/welcome_pages/wScreen3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/home_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/login_page.dart';
import 'package:e_shuttle/features/user_auth/presentation/pages/sign_up_page.dart';

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

  PageController pageController = PageController();
  String buttonText = "Skip";
  int currentPageIndex = 0; 

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged:(index){ 
              setState(() {
                currentPageIndex = index;
              if (index == 2){
                buttonText = "Finish";
              }else{
                buttonText = "Skip";
              }
              });
            } ,
            children: const [
              Screen1(),
              Screen2(),
              Screen3(),
            ],
          ),

          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    if (currentPageIndex == 2) {
                      // Navigate to the Login screen on "Finish"
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    } else {
                      // Skip to the last screen
                      pageController.jumpToPage(2);
                    }
                  },
                  child: Text(buttonText)
                ),
                SmoothPageIndicator(
                  controller: pageController, 
                  count: 3
                ),

                currentPageIndex == 2 ? const SizedBox (width: 10 ,): GestureDetector(
                  onTap: (){
                    pageController.nextPage(duration: Duration(milliseconds:500 ), curve: Curves.easeIn);
                  },
                  child: const Text("Next")
                )           
              ],
            ),
          )
        ],
      )
    );
  }
}