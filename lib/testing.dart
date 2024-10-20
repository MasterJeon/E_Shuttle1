import 'package:flutter/material.dart';

void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountVerification(),
    )
);

class AccountVerification extends StatefulWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  AccountVerificationState createState() => AccountVerificationState();
}

class AccountVerificationState extends State<AccountVerification> {
  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 68, 174, 250),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Set padding relative to screen size
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.03,
              horizontal: screenSize.width * 0.08,
            ),
            child: Column(
              children: [
                Text(
                  'Bus Route',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                busStop("Stop1","7.00 AM"),  
                busStop("Stop2","7.00 AM"),     
                busStop("Stop3","7.00 AM"),  
                busStop("Stop4","7.00 AM"), 
                busStop("Stop5","7.00 AM"),  
                busStop("Stop6","7.00 AM"), 
                busStop("Stop7","7.00 AM"),  
                busStop("Stop8","7.00 AM"),         
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget busStop(String stop, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        
        Text(
          
                  (stop),
                  style: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                  ),
                ),

        SizedBox(width: 20),
        Text(
                  (time),
                  style: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
        
        
      ],
    );
  }
}