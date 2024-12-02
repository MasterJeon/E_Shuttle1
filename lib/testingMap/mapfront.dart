import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_shuttle/home/myProfile/myProfile.dart';
import 'package:e_shuttle/testingMap/timewithdistance.dart';
//import 'package:e_shuttle/testingMap/distanceTlive.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() => runApp(const MapFront());

class MapFront extends StatefulWidget {
  const MapFront({super.key});

  @override
  State<MapFront> createState() => _MapFrontState();
}
class RouteDetails {
  final LatLng startLocation;
  final LatLng endLocation;
  final List<LatLng> waypoints;

  RouteDetails({
    required this.startLocation,
    required this.endLocation,
    required this.waypoints,
  });
}


class _MapFrontState extends State<MapFront> {
  late GoogleMapController mapController;
  late Future<UserProfile> _userProfileFuture;

  String cityname = 'fetching';

  final LatLng _center = const LatLng(6.81750000, 79.89027778);

  // To store user's current position
  LatLng _currentPosition = LatLng(6.81750000, 79.89027778);
  final Set<Marker> _markers = {};
  final Set<Marker> _marker = {};
  final Set<Polyline> _polylines = {};

  bool _isMapInitialized = false;
  bool _locationPermissionGranted = false;


  // Location stream subscription
  StreamSubscription<Position>? _positionStreamSubscription;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }



  @override
  void initState() {
    super.initState();
    //_getRoute();
    _markers.addAll(_createMarkers());
    _getRouteDataFromDB();
    //_getMarkerDataFromRoute();
    _requestLocationPermission();
  }

  Future<UserProfile> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('passenger') // Your Firestore collection name
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return UserProfile.fromFirestore(userDoc);
      }
    }
    return UserProfile(full_name: 'N/A', email: 'N/A', routeno: 'N/A');
  }

  Future<void> _getRouteDataFromDB() async {
    // Fetch the user's profile to get the selected route number
    final userProfile = await _fetchUserProfile();
    final selectedRouteNumber = userProfile.routeno;

    // Fetch only the route document that matches the selected route number
    if (selectedRouteNumber.isNotEmpty && selectedRouteNumber != 'N/A') {
      final routeDoc = await FirebaseFirestore.instance
          .collection('routes')
          .doc(selectedRouteNumber)
          .get();

      if (routeDoc.exists) {
        var data = routeDoc.data();

        if (data != null) {
          print("Route ID: ${routeDoc.id}");

          await _getMarkerDataFromRoute(routeDoc.id);

          print("Start Location: ${data['startLocation']}");
          print("End Location: ${data['endLocation']}");
          print("Waypoints: ${data['waypoints']}");

          // Use null-aware operators to safely access GeoPoint values
          GeoPoint? startGeo = data['startLocation'] as GeoPoint?;
          GeoPoint? endGeo = data['endLocation'] as GeoPoint?;

          // Determine time of day and set end location dynamically
          final now = DateTime.now();
          final morningEndTime = TimeOfDay(hour: 12, minute: 0);
          final eveningStartTime = TimeOfDay(hour: 12, minute: 1);

          // Define dynamic end location based on time
          GeoPoint? dynamicStartGeo;
          GeoPoint? dynamicEndGeo;
          if (now.hour < morningEndTime.hour ||
              (now.hour == morningEndTime.hour && now.minute <= morningEndTime.minute)) {
            // Morning: Set KDU as the end location
            dynamicEndGeo = startGeo; // Replace with actual KDU coordinates
            dynamicStartGeo = endGeo;
            print("It's morning. End location set to KDU.");
          } else if (now.hour > eveningStartTime.hour ||
              (now.hour == eveningStartTime.hour && now.minute >= eveningStartTime.minute)) {
            // Evening: Set route's end location
            dynamicStartGeo = startGeo;
            dynamicEndGeo = endGeo;
            print("It's evening. End location set to route's original end.");
          }

          print("Cityname after markers: $cityname");


          if (dynamicStartGeo != null && dynamicEndGeo != null) {
            Timestamp? passedStartGeoAtTimestamp = data['passedStartGeoAt'];
            DateTime? departureDateTime;
            String departureTimeFormatted = "N/A";

            // Convert the Timestamp to DateTime and format it
            if (passedStartGeoAtTimestamp != null) {
              DateTime passedStartGeoAt = passedStartGeoAtTimestamp.toDate();
              departureDateTime = passedStartGeoAtTimestamp.toDate().toLocal(); // Convert to local time
              departureTimeFormatted = DateFormat.jm().format(passedStartGeoAt); // e.g., "6:00 AM"
            }

            setState(() {
              if (dynamicEndGeo == endGeo) {
                // Evening
                departureLocation = "KDU";
                arrivalLocation = "$cityname";
              } else {
                // Morning
                departureLocation = "$cityname";
                arrivalLocation = "KDU";
              }
              departureTime = departureTimeFormatted; // Replace with dynamic value if available
              // Replace with dynamic value if available
              // Replace with dynamic value if calculated
            });

            LatLng start = LatLng(dynamicStartGeo.latitude, dynamicStartGeo.longitude);
            LatLng end = LatLng(dynamicEndGeo.latitude, dynamicEndGeo.longitude);

            List<LatLng> waypoints = (data['waypoints'] as List?)
                ?.map((wp) => LatLng(wp.latitude, wp.longitude))
                .toList() ?? [];

            print("Start: $start, End: $end, Waypoints: $waypoints");
            RouteDetails routeDetails = RouteDetails(
              startLocation: start,
              endLocation: end,
              waypoints: waypoints,
            );
            await _getDistanceMatrix(routeDetails, departureDateTime ?? DateTime.now()); // Use a suitable routeIndex (e.g., 0)


            // Call Google Directions API
            final directions = GoogleMapsDirections(apiKey: "AIzaSyBRDV8VbzhAJvMyfWuqpObUKGOFBZ_kcgs");
            final result = await directions.directionsWithLocation(
              Location(lat: start.latitude, lng: start.longitude),
              Location(lat: end.latitude, lng: end.longitude),
              waypoints: waypoints.map((wp) => Waypoint(value: '${wp.latitude},${wp.longitude}')).toList(),
            );

            if (result.isOkay) {
              List<LatLng> routeCoords = _decodePolyline(result.routes[0].overviewPolyline.points);
              setState(() {
                _polylines.add(Polyline(
                  polylineId: PolylineId(routeDoc.id),
                  visible: true,
                  points: routeCoords,
                  color: Colors.blue,
                  width: 4,
                ));
              });
            }

          } else {
            print("Start or End location is null.");
          }
        } else {
          print("Route data is null.");
        }
      } else {
        print("No route found for the selected route number: $selectedRouteNumber.");
      }
    } else {
      print("No valid route number found in user profile: $selectedRouteNumber.");
    }
  }

  Future<void> _getMarkerDataFromRoute(String routeId) async {
    final markersSnapshot = await FirebaseFirestore.instance
        .collection('routes')
        .doc(routeId) // routeId must be a String
        .collection('markers')
        .get();

    print("Total markers fetched for route $routeId: ${markersSnapshot.docs.length}");

    setState(() {
      String highestPriceMarkerName = '';
      int highestTicketPrice = 0;

      for (var doc in markersSnapshot.docs) {
        var data = doc.data();
        print("Marker ID: ${doc.id}");
        print("Coordinates: ${data['coordinates']}");
        print("City Name: ${data['cityName']}");
        print("Ticket Price: ${data['ticketPrice']}");
        if (data['ticketPrice'] > highestTicketPrice) {
          highestTicketPrice = data['ticketPrice'];
          cityname = data['cityName'] ?? 'Unknown';
          print("City iss: $cityname");// Marker name field
        }

        GeoPoint geoPoint = data['coordinates'];
        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);

        // Add dynamic markers from Firestore
        _markers.add(
          createMarker(
            doc.id, // Marker ID from Firestore document
            position, // LatLng position from Firestore document
            data['cityName'], // City name from Firestore document
            data['ticketPrice'].toString(), // Ticket price converted to string
          ),
        );
      }

    });
  }





  /*Future<void> _getRouteDataFromDB() async {
    final routesSnapshot = await FirebaseFirestore.instance.collection('routes').get();
    print("Total routes fetched: ${routesSnapshot.docs.length}");final directions = GoogleMapsDirections(apiKey: "AIzaSyBRDV8VbzhAJvMyfWuqpObUKGOFBZ_kcgs");

    for (var doc in routesSnapshot.docs) {
      var data = doc.data();
      print("Route ID: ${doc.id}");

      _getMarkerDataFromRoute(doc.id);

      print("Start Location: ${data['startLocation']}");
      print("End Location: ${data['endLocation']}");
      print("Waypoints: ${data['waypoints']}");
      GeoPoint startGeo = data['startLocation'];
      GeoPoint endGeo = data['endLocation'];

      LatLng start = LatLng(startGeo.latitude, startGeo.longitude);
      LatLng end = LatLng(endGeo.latitude, endGeo.longitude);

      List<LatLng> waypoints = (data['waypoints'] as List)
          .map((wp) => LatLng(wp.latitude, wp.longitude))
          .toList();

      print("Start: $start, End: $end, Waypoints: $waypoints");

      // Call Google Directions API
      final result = await directions.directionsWithLocation(
        Location(lat: start.latitude, lng: start.longitude),
        Location(lat: end.latitude, lng: end.longitude),
        waypoints: waypoints.map((wp) => Waypoint(value: '${wp.latitude},${wp.longitude}')).toList(),
      );

      if (result.isOkay) {
        List<LatLng> routeCoords = _decodePolyline(result.routes[0].overviewPolyline.points);
        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId(doc.id),
            visible: true,
            points: routeCoords,
            color: Colors.blue,
            width: 4,
          ));
        });
      }
    }
  }*/



  // Fetch marker data from Firestore
  /*Future<void> _getMarkerDataFromDB() async {
    final markersSnapshot = await FirebaseFirestore.instance.collection('markers').get();
    print("Total markers fetched: ${markersSnapshot.docs.length}");

    setState(() {
      for (var doc in markersSnapshot.docs) {
        var data = doc.data();
        print("Marker ID: ${doc.id}");
        print("Coordinates: ${data['coordinates']}");
        print("City Name: ${data['cityName']}");
        print("Ticket Price: ${data['ticketPrice']}");

        GeoPoint geoPoint = data['coordinates'];
        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);

        // Use createMarker method to generate the marker
        _markers.add(
          createMarker(
            doc.id, // Marker ID from Firestore document
            position, // LatLng position from Firestore document
            data['cityName'], // City name from Firestore document
            data['ticketPrice'].toString(), // Ticket price converted to string
          ),
        );


        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: position,
            infoWindow: InfoWindow(
              title: data['cityName'],
              snippet: "Ticket price: Rs." + data['ticketPrice'].toString(),
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }
    });
  }*/



  /*void _getRoute() async {
    String googleAPIKey = "AIzaSyBRDV8VbzhAJvMyfWuqpObUKGOFBZ_kcgs";
    final directions = GoogleMapsDirections(apiKey: googleAPIKey);

    for (int i = 0; i < _routes.length; i++) {
      final routeDetails = _routes[i];
      final waypoints = routeDetails.waypoints.map((stop) => Waypoint(
            value: '${stop.latitude},${stop.longitude}',
          )).toList();

      final result = await directions.directionsWithLocation(
        Location(lat: routeDetails.startLocation.latitude, lng: routeDetails.startLocation.longitude),
        Location(lat: routeDetails.endLocation.latitude, lng: routeDetails.endLocation.longitude),
        waypoints: waypoints,
      );

      if (result.isOkay) {
        List<LatLng> routeCoords = _decodePolyline(result.routes[0].overviewPolyline.points);

        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId("route_$i"),
            visible: true,
            points: routeCoords,
            color: Colors.blue,
            width: 4,
          ));
        });
      }
    }
  }*/

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!serviceEnabled || permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _getCurrentLocation();
    }
  }

  Future<void> _getDistanceMatrix(RouteDetails route, DateTime departureTime) async {
    String googleAPIKey = "AIzaSyBRDV8VbzhAJvMyfWuqpObUKGOFBZ_kcgs";
    // Construct origins and destinations
    String origins = '${route.startLocation.latitude},${route.startLocation.longitude}';
    String destinations = '${route.endLocation.latitude},${route.endLocation.longitude}';

    // If there are waypoints, concatenate them
    if (route.waypoints.isNotEmpty) {
      String waypointStr = route.waypoints.map((point) => '${point.latitude},${point.longitude}').join('|');
      origins += '|$waypointStr';
    }

    // Make the Distance Matrix API request
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destinations&key=$googleAPIKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract distance and duration
        final elements = data['rows'][0]['elements'][0];
        final distance = elements['distance']['text'];
        final duration = elements['duration']['text'];

        print("Locations fetched: $origins , $destinations");

        // Parse the duration (in minutes or hours) and add it to the current time
        final durationParts = duration.split(' ');
        int durationMinutes = 0;

        // Check if the duration contains hours and minutes
        if (durationParts.length == 4) {
          durationMinutes = int.parse(durationParts[0]) * 60 + int.parse(durationParts[2]);
        } else if (durationParts.length == 2) {
          if (durationParts[1] == "hours" || durationParts[1] == "hour") {
            durationMinutes = int.parse(durationParts[0]) * 60;
          } else {
            durationMinutes = int.parse(durationParts[0]);
          }
        }



        // Calculate the arrival time by adding the duration to the current time
        final currentTime = DateTime.now();
        final arrivalTimee = departureTime.add(Duration(minutes: durationMinutes));

        //final arrivalTimee = currentTime.add(Duration(minutes: durationMinutes));

        // Format the arrival time
        //final formattedArrivalTime = DateFormat.jm().format(arrivalTime);
        final formattedArrivalTime = DateFormat.jm().format(arrivalTimee);

        // Store the distance and duration
        setState(() {
          ddistance = distance; // Replace with dynamic value if calculated
          dduration = duration;
          arrivalTime = formattedArrivalTime;
        });
        print("Locations fetched: $origins , $destinations");

        print('Distance: $distance, Duration: $duration');
      } else {
        print('Error: Unable to retrieve data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _initializeMap(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isMapInitialized = true;
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _updatePosition(position);

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position newPosition) {
      _updatePosition(newPosition);
    });
  }

  void _updatePosition(Position position) {
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      /*_markers.add(
        Marker(
          markerId: const MarkerId('userLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );*/

      if (_isMapInitialized) {
        mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  String departureLocation = "Fetching..."; // Replace with data fetched from the database
  String arrivalLocation = "Fetching..."; // Replace with data fetched from the database
  String departureTime = "Fetching..."; // Replace with data fetched from the database
  String arrivalTime = "Fetching..."; // Replace with data fetched from the database
  String ddistance = "Fetching..."; // Replace with data fetched from the database
  String dduration = "Fetching..."; // Replace with data fetched from the database

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(160.0), // Adjust the height as needed
          child: AppBar(
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(38, 201, 255, 1),
                    Color.fromRGBO(0, 115, 239, 1),
                    Color.fromRGBO(0, 69, 230, 1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0), // Adjust padding here
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Departure Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Departure',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 4.0), // Space between rows
                        Text(
                          departureTime, // Replace with your actual departure time
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 4.0), // Space between rows
                        Text(
                          departureLocation, // Replace with your actual departure location
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    // Center Info (Distance and Duration)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ddistance,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8.0), // Space between rows
                        Row(
                          children: [
                            Text(
                              '-   -   -  -', // Replace with desired number of dashes
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w900, color: const Color.fromARGB(255, 255, 255, 255)),
                            ),
                            SizedBox(width: 8), // Space between dashes and arrow
                            Icon(
                              Icons.arrow_forward, // Arrow icon between Departure and Arrival
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        SizedBox(height: 8.0), // Space between rows
                        Text(
                          dduration,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    // Arrival Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Arrival',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 4.0), // Space between rows
                        Text(
                          arrivalTime, // Replace with your actual arrival time
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 4.0), // Space between rows
                        Text(
                          arrivalLocation, // Replace with your actual arrival location
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: Stack( // Use Stack to overlay the button on the map
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.0,
              ),
              //markers: _createMarkers(),
              markers: _markers,
              //_markers,
              //_createMarkers(),
              polylines: _polylines,
              myLocationEnabled: true, // Shows the blue dot for current location
              myLocationButtonEnabled: true, // Enables the my location button
            ),
            Positioned(
              bottom: 20, // Adjusts the button's vertical position
              left: 20, // Adjusts the button's horizontal position
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLiveRoute()),
                  );

                  // Handle tap action here
                  print('Tap to Track button pressed!');
                },
                child: Container(
                  width: 120, // Button width
                  height: 50,
                   decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 230, 81, 0),
                          const Color.fromRGBO(239, 108, 0, 1),
                          const Color.fromRGBO(255, 167, 38, 1),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ), // Button height
                  child: Center(
                    child: Text(
                      'Tap to Track',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      const Marker(
        markerId: MarkerId('KDU'),
        position: LatLng(6.817801415099614, 79.89069891600366),
        infoWindow: InfoWindow(title: "KDU"),
      ),
      const Marker(
        markerId: MarkerId('UHKDU'),
        position: LatLng(6.825240929708998, 79.9082921331989),
        infoWindow: InfoWindow(title: "UHKDU"),
      ),
      };
  }

  Marker createMarker(String markerId, LatLng position, String cityName, String price) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(
        title: cityName,  // Use the city name as the title
        snippet: "Ticket price: Rs. " + price,  // Include the ticket price in the snippet
      ),
      icon: BitmapDescriptor.defaultMarker, // Use default marker icon
    );
  }
/*Marker createMarker(String markerId, LatLng position, String price) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId, snippet: "Ticket price: Rs."+price),
      icon: BitmapDescriptor.defaultMarker,
    );
  }*/

}
