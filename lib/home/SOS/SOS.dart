import 'package:e_shuttle/home/SOS/ambulance.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SOSApp());
}

class SOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SOS(),
    );
  }
}

class SOS extends StatelessWidget {
  var height, width;

  List<String> imgSrc = [
    "assets/images/ambulance.png",
    "assets/images/hospital.png",
    "assets/images/policeman.png",
    "assets/images/kdu_logo.png",
  ];

  List<String> titles = [
    "Ambulance Services",
    "Nearest Hospital",
    "Police Services",
    "Inform KDU",
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        height: height,
        width: width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 90,
                left: 30,
                right: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
                children: [
                  Text(
                    "Emergency Service",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center, // Center text
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, // Make the width span the container
                    child: Text(
                      "Click the relevant tab to direct a phone call",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center, // Center and balance the subtitle text
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // Spacing between title and grid
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 25,
                          crossAxisSpacing: 20,
                        ),
                        padding: EdgeInsets.all(20),
                        itemCount: imgSrc.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // Handle onTap for each service
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AmbulancePage()),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HospitalPage()),
                                );
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PolicePage()),
                                );
                              } else if (index == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => KDUPage()),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    imgSrc[index],
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text(
                                    titles[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 60), // Space for bottom navigation bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
