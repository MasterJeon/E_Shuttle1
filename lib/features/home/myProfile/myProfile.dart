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
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        // Set padding relative to screen size
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.08,
        ),
        child: Column(
          children: [
            Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('b 3s.jpg'), // Replace with your image asset
            ),
            SizedBox(height: 24),
            Text(
                  'Sasini Lekamge',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
            Text(
                  'sasinilekamge@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
            SizedBox(height: 28),
            profileTab("My Information", CupertinoIcons.person),
            SizedBox(height: 8),
            profileTab("Notifications", CupertinoIcons.news),
            SizedBox(height: 8),
            profileTab("Share Live Location", CupertinoIcons.location),
            SizedBox(height: 8),
            profileTab("Trusted Contacts", CupertinoIcons.person_2),
            SizedBox(height: 8),
            profileTab("App Setings", CupertinoIcons.settings),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  profileTab(String title, IconData iconData){
    return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListTile(
                title: Text(title),
                //subtitle: Text(subtitle),
                leading: Icon(iconData),
                trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                tileColor: Colors.white,
              ),
    );
  }
}


