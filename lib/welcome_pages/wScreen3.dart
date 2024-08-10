import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget{
  const Screen3 ({super.key});

  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/sos2.png"),
        const SizedBox(height: 40,),
        const Text("Stay Connected & Safe", style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w400
        ),
        textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20,),
        Container(
          padding:EdgeInsets.symmetric(horizontal: 20),
          child: Text("Your safety, our priority. Quickly alert security with our SOS feature and receive real-time notifications. Customize your profile and enjoy a personalized experience.", 
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }    
}