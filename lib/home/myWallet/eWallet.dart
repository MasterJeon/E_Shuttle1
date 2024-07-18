import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyProfile(),
    )
);

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        // Set padding relative to screen size
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.08,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
            child: Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 77, 157, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'E-Wallet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 34),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        'Rs. 5000.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            SizedBox(height: 96),
            
            profileTab("Recharge Balance"),
            SizedBox(height: 16),
            profileTab("Refund"),
            SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
  Widget profileTab(String title, {Widget? trailing}){
    return Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 175, 77),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    color: const Color.fromARGB(255, 5, 9, 11).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListTile(
                
                title: Text(
                  title,
                  style: TextStyle(color : const Color.fromARGB(255, 0, 0, 0)),),
                
                //subtitle: Text(subtitle),
                //leading: Icon(iconData),
                trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                tileColor: const Color.fromARGB(255, 255, 255, 255),
              ),
    );
  }
}


