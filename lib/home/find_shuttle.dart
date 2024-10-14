import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String? selectedStart = "KDU"; // Set default value to KDU
  String? selectedDestination = "KDU"; // Set default value to KDU
  String? selectedRoute;
  String? selectedStop;
  double? ticketPrice;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchRouteDetails(String stop) async {
    final routesRef = firestore.collection('routes');
    final routesSnapshot = await routesRef.get();

    if (routesSnapshot.docs.isNotEmpty) {
      for (var routeDoc in routesSnapshot.docs) {
        final markersRef = routeDoc.reference.collection('markers');

        // Attempt to fetch the marker document using the stop name directly
        final markerDoc = await markersRef.doc(stop).get();

        if (markerDoc.exists) {
          // Fetching the ticket price, ensuring correct type handling
          final priceData = markerDoc.data()?['ticketPrice'];
          double price = 0.00; // Default value

          if (priceData is double) {
            price = priceData; // Use directly if it's a double
          } else if (priceData is int) {
            price = priceData.toDouble(); // Convert to double if it's an int
          }

          final routeNumber = routeDoc.id; // Get the route number

          // Set state only if valid data is found
          if (mounted) {
            setState(() {
              ticketPrice = price; // Set the ticket price for the selected stop
              selectedRoute = routeNumber; // Set the selected route ID
            });
          }
          return; // Exit once the price and route are found
        }
      }
      // If no marker found, reset ticket price
      if (mounted) {
        setState(() {
          ticketPrice = 0.00;
          selectedRoute = null; // Clear selected route
        });
      }
    } else {
      // No routes found
      if (mounted) {
        setState(() {
          ticketPrice = 0.00;
          selectedRoute = null;
        });
      }
    }
  }



  Widget buildShuttleDetails() {
    final pickupPoint = selectedStart ?? "Kottawa";
    final pickOffPoint = selectedDestination ?? "KDU";
    final priceString = ticketPrice != null && ticketPrice! > 0
        ? "Rs. ${ticketPrice!.toStringAsFixed(2)}/="
        : "Not Available";


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
                "$selectedRoute: $pickupPoint ➔ $pickOffPoint",
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
                  "Ticket Price: $priceString",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),

              // Route Points
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

              // Placeholder for Distance and Time (if not calculated)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Distance: N/A", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  SizedBox(width: 5.0),
                  Dash(
                    direction: Axis.horizontal,
                    length: 100,
                    dashLength: 5,
                    dashColor: Colors.white,
                  ),
                  SizedBox(width: 5.0),
                  Text("Time: N/A", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void handleStartSelection(String? value) {
    setState(() {
      selectedStart = value;
      selectedDestination = "KDU"; // Automatically set destination to KDU
      // Set selectedStop to selectedDestination, making sure to handle null.
      selectedStop = selectedStart ?? ''; // Set selectedStop to selectedDestination if not null
    });
    if (selectedStop != null) {
      print('Fetching details for Stop: $selectedStop');
      fetchRouteDetails(selectedStop!); // Fetch details for the selected route
    }
  }

  void handleDestinationSelection(String? value) {
    setState(() {
      selectedDestination = value;
      selectedStart = "KDU"; // Automatically set start to KDU

      // Set selectedStop to selectedDestination, making sure to handle null.
      selectedStop = selectedDestination ?? ''; // Set selectedStop to selectedDestination if not null
    });

    // Check if selectedStop is not null or empty before proceeding.
    if (selectedStop!=null) {
      print('Fetching details for Stop: $selectedStop');
      fetchRouteDetails(selectedStop!); // Fetch details for the selected route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text("FIND MY SHUTTLE", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Start", style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: selectedStart, // Set the current selected value
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: [
                "KDU", "UH-KDU", "Aththidiya", "Bandaragama", "Delgoda", "Gammanpila", "Godagama",
                "Gonapola", "Horana", "JaEla", "Kaduwela", "Kesbewa", "Kindelapitiya",
                "Koswatta", "Kottawa", "Kumbuka", "Maharagama", "Negombo",
                "Nittambuwa", "Nugegoda", "Pahathgama", "Panadura",
                "Peliyagoda", "Piliyandala", "Pokunuwita", "Polgasowita",
                "Weliweriya", "Yakkala"
              ].map((String stop) {
                return DropdownMenuItem(value: stop, child: Text(stop));
              }).toList(),
              onChanged: handleStartSelection,
            ),
            SizedBox(height: 20.0),
            Text("Destination", style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: selectedDestination, // Set the current selected value
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: [
                "KDU", "UH-KDU", "Aththidiya", "Bandaragama", "Delgoda", "Gammanpila", "Godagama",
                "Gonapola", "Horana", "JaEla", "Kaduwela", "Kesbewa", "Kindelapitiya",
                "Koswatta", "Kottawa", "Kumbuka", "Maharagama", "Negombo",
                "Nittambuwa", "Nugegoda", "Pahathgama", "Panadura",
                "Peliyagoda", "Piliyandala", "Pokunuwita", "Polgasowita",
                "Weliweriya", "Yakkala"
              ].map((String stop) {
                return DropdownMenuItem(value: stop, child: Text(stop));
              }).toList(),
              onChanged: handleDestinationSelection,
            ),
            SizedBox(height: 20.0),
            Expanded(child: buildShuttleDetails()),
          ],
        ),
      ),
    );
  }
}
