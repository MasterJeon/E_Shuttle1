import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shuttle/home/home.dart';

class ChangeRoute extends StatefulWidget{
  const ChangeRoute({Key? key}) : super(key: key);

  @override
  ChangeRouteState createState() => ChangeRouteState();
}

class ChangeRouteState extends State<ChangeRoute> {
  int selected = 0;


  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
            appBar: AppBar(title: const Text("Change Your Route"),
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Set padding relative to screen size
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.03,
              horizontal: screenSize.width * 0.08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Text(
                  "By selecting your route, you'll receive daily updates on the bus location along your route.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(162, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Note: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'You can change your route at any time.',
                        style: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 35),
                Container(
                  padding: EdgeInsets.all(28),
                  height: 150, // Adjust the height as needed
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Route',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Add spacing between text and row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          routeOption("1", 1),
                          routeOption("2", 2),
                          routeOption("3", 3),
                          routeOption("4", 4),
                          routeOption("5", 5),
                          routeOption("6", 6),
                        ],
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget routeOption(String text, int index) {
    return SizedBox(
      width:40,
      child: TextButton(
        onPressed: () {
          setState(() {
            selected = index;
          });
          // Call addRouteNo when a route is selected
          addRouteNo(context, text);  // Pass the selected route as the 'routeno'
          Navigator.pushNamed(context, "/home");
        },
        child: Text(
          text,
          //textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: (selected == index) ? Colors.green : Colors.blueGrey,
          ),
        ),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (selected == index) ? Colors.green : Colors.blueGrey,
              ),
            ),
          ),),
      ),
    );
  }

  Future<void> addRouteNo(BuildContext context, String routeno) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final userDocRef = FirebaseFirestore.instance.collection('passenger').doc(user.uid);

      // Update the route number in the Firestore database
      await userDocRef.update({
        'routeno': "r" + routeno,  // Update with the selected routeno
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Route no added successfully')),
      );
    } catch (e) {
      print('Error adding route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add route: $e')),
      );
    }
  }
}