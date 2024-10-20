import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShuttleDetailsPage(),
    );
  }
}

class ShuttleDetailsPage extends StatefulWidget {
  @override
  _ShuttleDetailsPageState createState() => _ShuttleDetailsPageState();
}

class _ShuttleDetailsPageState extends State<ShuttleDetailsPage> {
  String? selectedStart;
  String? selectedDestination;

  Widget buildShuttleDetails() {
    final pickupPoint = selectedStart ?? "Kottawa";
    final pickOffPoint = selectedDestination ?? "KDU";
    final ticketPrice = "Rs. 180/=";
    final travelTime = "1h 30min";
    final distance = "2Km";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Route Widget
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "R2: $pickupPoint ➔ $pickOffPoint",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),

        // Ticket Price and Route Details Widget
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              // Ticket Price
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Ticket Price: $ticketPrice",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),

              // Route Points with Dotted Line
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Pickup Point:", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                      SizedBox(height: 5.0),
                      Text(pickupPoint, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Pick off Point:", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                      SizedBox(height: 5.0),
                      Text(pickOffPoint, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),

              // Dotted Line with Distance and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(distance, style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  SizedBox(width: 5.0),
                Dash(
                  direction: Axis.horizontal,
                  length: 100,
                  dashLength: 5,
                  dashColor: Colors.white,
                ),
                  SizedBox(width: 5.0),
                  Text(travelTime, style: TextStyle(fontSize: 16.0, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Add navigation logic here
          },
        ),*/
        title: Text("FIND MY SHUTTLE", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        /*actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Add menu functionality here
            },
          ),
        ],*/
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Start", style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ["KDU", "UH-KDU", "Aththidiya", "Bandaragama", "Delgoda", "Gammanpila", "Godagama","Gonapola", "Horana", "Ja-Ela", "Kaduwela", "Kesbewa", "Kindelapitiya", "Koswatta","Kottawa", "Kumbuka", "Maharagama", "Negambo", "Nittambuwa", "Nugegoda", "Pahathgama","Panadura", "Peliyagoda", "Piliyandala", "Pokunuwita", "Polgasowita", "Weliweriya", "Yakkala"].map((String stop) {
                return DropdownMenuItem(value: stop, child: Text(stop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStart = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text("Destination", style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ["KDU", "UH-KDU", "Aththidiya", "Bandaragama", "Delgoda", "Gammanpila", "Godagama","Gonapola", "Horana", "Ja-Ela", "Kaduwela", "Kesbewa", "Kindelapitiya", "Koswatta","Kottawa", "Kumbuka", "Maharagama", "Negambo", "Nittambuwa", "Nugegoda", "Pahathgama","Panadura", "Peliyagoda", "Piliyandala", "Pokunuwita", "Polgasowita", "Weliweriya", "Yakkala"].map((String destination) {
                return DropdownMenuItem(value: destination, child: Text(destination));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDestination = value;
                });
              },
            ),
            SizedBox(height: 20.0),

            // Display Shuttle Details after Selection
            if (selectedStart != null && selectedDestination != null) buildShuttleDetails(),
          ],
        ),
      ),
    );
  }
}
