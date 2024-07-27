import 'package:flutter/material.dart';

class SOS extends StatefulWidget{
  @override

  State<SOS> createState() => SOSState();
}

class SOSState extends State<SOS>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Service')),
      body: Center(
        child: Text('SOS-Emergency services', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}