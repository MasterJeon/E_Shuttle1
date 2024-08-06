import 'package:e_shuttle/main.dart';
import 'package:e_shuttle/welcome_pages/wScreen1.dart';
import 'package:e_shuttle/welcome_pages/wScreen2.dart';
import 'package:e_shuttle/welcome_pages/wScreen3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
              currentPageIndex = index;
              if (index == 3){
                buttonText = "Finish";
              }else{
                buttonText = "Skip";
              }
              setState(() {
                
              });
            } ,
            children: const [
              Screen1(),
              Screen2(),
              Screen3(),
            ],
          ),

          Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){

                  },
                  child: const Text(buttonText)
                ),
                SmoothPageIndicator(
                  controller: pageController, 
                  count: 3
                ),

                currentPageIndex == 3 ? const SizedBox (width: 10 ,): GestureDetector(
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