import 'package:flutter/material.dart';



void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        // Set padding relative to screen size
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.08,
        ),
        child: Column(
          children: [
          SizedBox(height: 96),
          SizedBox(
              width: 350,
              height: 150,
              child: Image.asset('assets/download.png'), // Replace with your image asset path
            ),
          SizedBox(height: 96),
                SizedBox(height: 24),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(height: 10),
                Text(
                  "Getting your day to day shuttle update is now just a matter of some clicks ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 100),
                buildButtons(),
          ],
        ),
      ),
    );
  }
  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        
          ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 67, 59, 59),
              foregroundColor: Colors.white,
            ),
            child: Text('Get Started'),
          ),
        
      ],
    );
  }
}


