import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget{
  const Screen1 ({super.key});

  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/real_time_tracking.png"),
        const SizedBox(height: 40,),
        const Text("Real-Time Bus Tracking", style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w400
        ),
        textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20,),
        Container(
          padding:EdgeInsets.symmetric(horizontal: 20),
          child: Text("Never miss your ride again ! Get real-time updates on bus locations and arrival times. No more waiting... Stay informed and plan your journey with ease.", 
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
