import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ETickets(),
    )
);

class ETickets extends StatefulWidget {
  const ETickets({Key? key}) : super(key: key);

  @override
  ETicketsState createState() => ETicketsState();
}

class ETicketsState extends State<ETickets> {
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
                Text(
                  'E-Tickets',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 60),
                
                Text(
                  'Scan to Pay...!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(height: 10),
                Text(
                  "Validate your code at the bus entrance before and after your arrival to exit.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                SizedBox(height: 28),
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      
                      SizedBox(height: 60),
                      
                      Text(
                        "                 QR Code                 "
                      ),
                      SizedBox(height: 60),
                      
                    ],
                  ),
                ),
                SizedBox(height: 80),   
                buildButtons(),             
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
          onPressed: () {
            // Handle QR code scanner button press
          },
          child: Text('Check Balance'),
        ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
          onPressed: () {
            // Handle payment button press
          },
          child: Text('Recharge'),
        ),
        ),
      ],
    );
  }
}