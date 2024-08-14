import 'package:flutter/material.dart';

class changeRoute extends StatelessWidget{
  const changeRoute ({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Change My Route"),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
      ),
    );
  }    
}