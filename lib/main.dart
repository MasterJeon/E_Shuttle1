import 'package:flutter/material.dart';
import 'package:e_shuttle/home/SOS/SOS.dart';
import 'package:e_shuttle/home/eTickets/tickets.dart';
import 'package:e_shuttle/home/feedbacks/feedbacks.dart';
import 'package:e_shuttle/home/home.dart';
import 'package:e_shuttle/home/myProfile/profile.dart';
import 'package:e_shuttle/home/myWallet/wallet.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  State<MyApp> createState() => _MyAppState();  
}

class _MyAppState extends State<MyApp>{

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      
      routes: { 
          '/homePage':(context) => HomePage(),
          '/profilePage':(context) => Profile(),
          '/wallet':(context) => Wallet(),
          '/sos':(context) => SOS(),
          '/feedbacks':(context) => Feedbacks(),
          '/tickets':(context) => Tickets(),
      },
    );
  }
}