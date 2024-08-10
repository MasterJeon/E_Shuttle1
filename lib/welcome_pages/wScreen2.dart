import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget{
  const Screen2 ({super.key});

  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/e_ticket.png"),
        const SizedBox(height: 40,),
        const Text("Easy Digital Ticketing & E-Wallet", style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w400
        ),
        textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20,),
        Container(
          padding:EdgeInsets.symmetric(horizontal: 20),
          child: Text("Say goodbye to paper tickets. Purchase and store your tickets digitally and securely with our integrated E-Wallet, Your digital ticket and balance at your fingertips, ready whenever you are.", 
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
