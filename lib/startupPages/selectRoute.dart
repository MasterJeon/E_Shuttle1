import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectRoute(),
    )
);

class SelectRoute extends StatefulWidget {
  const SelectRoute({Key? key}) : super(key: key);

  @override
  SelectRouteState createState() => SelectRouteState();
}

class SelectRouteState extends State<SelectRoute> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
                SizedBox(height: 96),
                SizedBox(height: 24),
                Text(
                  'Select Your Route',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(height: 10),
                Text(
                  "By selecting your route, you'll receive daily updates on the bus location along your route.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(162, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14,),
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

                SizedBox(height: 28),
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
                      SizedBox(height: 16), // Add spacing between text and row
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

                SizedBox(height: 18),
                Text(
                  "Didn't you receive any code?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18),
                Text(
                  "Resend New Code",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
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
      Navigator.pushNamed(context, "/login");
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