import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_shuttle/home/myProfile/myProfile.dart';
import 'package:e_shuttle/testingMap/stopsandtime.dart';

void main() => runApp(const MyLiveRoute());

class MyLiveRoute extends StatefulWidget {
  const MyLiveRoute({super.key});

  @override
  State<MyLiveRoute> createState() => _MyLiveRouteState();
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

class _MyLiveRouteState extends State<MyLiveRoute> {
  late GoogleMapController mapController;
  late Future<UserProfile> _userProfileFuture;

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

  // List to store distance and duration for each route
  List<Map<String, String>> _routeSummaries = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _markers.addAll(_createMarkers());
    _getRouteDataFromDB();
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

  Future<void> _getMarkerDataFromRoute(String routeId) async {
    final markersSnapshot = await FirebaseFirestore.instance
        .collection('routes')
        .doc(routeId) // routeId must be a String
        .collection('markers')
        .get();

    print("Total markers fetched for route $routeId: ${markersSnapshot.docs.length}");

    setState(() {
      for (var doc in markersSnapshot.docs) {
        var data = doc.data();
        print("Marker ID: ${doc.id}");
        print("Coordinates: ${data['coordinates']}");
        print("City Name: ${data['cityName']}");
        print("Ticket Price: ${data['ticketPrice']}");

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

          _getMarkerDataFromRoute(routeDoc.id);

          print("Start Location: ${data['startLocation']}");
          print("End Location: ${data['endLocation']}");
          print("Waypoints: ${data['waypoints']}");

          // Use null-aware operators to safely access GeoPoint values
          GeoPoint? startGeo = data['startLocation'] as GeoPoint?;
          GeoPoint? endGeo = data['endLocation'] as GeoPoint?;

          if (startGeo != null && endGeo != null) {
            LatLng start = LatLng(startGeo.latitude, startGeo.longitude);
            LatLng end = LatLng(endGeo.latitude, endGeo.longitude);

            List<LatLng> waypoints = (data['waypoints'] as List?)
                ?.map((wp) => LatLng(wp.latitude, wp.longitude))
                .toList() ?? [];

            print("Start: $start, End: $end, Waypoints: $waypoints");

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
            await _getDistanceMatrix(routeDetails, i);
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

  }*/
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

          _getMarkerDataFromRoute(routeDoc.id);

          print("Start Location: ${data['startLocation']}");
          print("End Location: ${data['endLocation']}");
          print("Waypoints: ${data['waypoints']}");

          // Use null-aware operators to safely access GeoPoint values
          GeoPoint? startGeo = data['startLocation'] as GeoPoint?;
          GeoPoint? endGeo = data['endLocation'] as GeoPoint?;

          if (startGeo != null && endGeo != null) {
            LatLng start = LatLng(startGeo.latitude, startGeo.longitude);
            LatLng end = LatLng(endGeo.latitude, endGeo.longitude);

            List<LatLng> waypoints = (data['waypoints'] as List?)
                ?.map((wp) => LatLng(wp.latitude, wp.longitude))
                .toList() ?? [];

            print("Start: $start, End: $end, Waypoints: $waypoints");

            // Create a RouteDetails object
            RouteDetails routeDetails = RouteDetails(
              startLocation: start,
              endLocation: end,
              waypoints: waypoints,
            );

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
            // Call _getDistanceMatrix with routeDetails and an index
            await _getDistanceMatrix(routeDetails); // Use a suitable routeIndex (e.g., 0)
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

      // Call the Distance Matrix API to get distance and time
      await _getDistanceMatrix(routeDetails, i);
    }
  }*/


  /*Future<void> _getDistanceMatrix(RouteDetails route, int routeIndex) async {
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
        final arrivalTime = currentTime.add(Duration(minutes: durationMinutes));

        // Format the arrival time
        final formattedArrivalTime = DateFormat.jm().format(arrivalTime);

        // Store the distance and duration
        setState(() {
          if (_routeSummaries.length <= routeIndex) {
            _routeSummaries.add({
              'distance': distance,
              'duration': duration, // Add duration
              'arrival_time': formattedArrivalTime,
            });
          } else {
            _routeSummaries[routeIndex] = {
              'distance': distance,
              'duration': duration, // Add duration
              'arrival_time': formattedArrivalTime,
            };
          }
        });

        print('Distance: $distance, Duration: $duration');
      } else {
        print('Error: Unable to retrieve data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/
  Future<void> _getDistanceMatrix(RouteDetails route) async {
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
        final arrivalTime = currentTime.add(Duration(minutes: durationMinutes));

        // Format the arrival time
        final formattedArrivalTime = DateFormat.jm().format(arrivalTime);

        // Store the distance and duration
        setState(() {
          _routeSummaries.add({
            'distance': distance,
            'duration': duration, // Add duration
            'arrival_time': formattedArrivalTime,
          });
        });

        print('Distance: $distance, Duration: $duration');
      } else {
        print('Error: Unable to retrieve data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps in Flutter'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.0,
              ),
              //markers: _createMarkers(),
              markers: _markers,
              polylines: _polylines,
            ),
            if (_routeSummaries.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: RouteSummaryWidget(
                  distance: _routeSummaries[0]['distance'] ?? '',
                  duration: _routeSummaries[0]['duration'] ?? '',
                  arrivalTime: _routeSummaries[0]['arrival_time'] ?? '',  // Ensure this is arrival_time
                ),
              ),
            Positioned(
              bottom: 90,
              left: 10,
              // Navigate to the BusStopPage on tap
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LiveLocations()),
                  );
                },
              child: Container(
                padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.directions_bus_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Bus Stops',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
}

// Add the RouteSummaryWidget class here
class RouteSummaryWidget extends StatelessWidget {
  final String distance;
  final String duration;
  final String arrivalTime;

  const RouteSummaryWidget({
    Key? key,
    required this.distance,
    required this.duration,
    required this.arrivalTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adjust styling as needed
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0), // Increased left padding
            child: Icon(Icons.directions_bus, color: Colors.blue),
          ),  // Bus icon added here
          Expanded(
            child: Center(// Expands the column to take available space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,  // Centers the content vertically within the Column
                children: [
                  Text(
                    '$duration',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Centers the text horizontally
                  ),
                  Text(
                    '$distance | $arrivalTime',
                    style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Centers the text horizontally
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0), // Add padding to create space between text and logo
            child: Image.asset(
              'assets/kdu_logo.png', // Path to your logo image
              height: 50,  // Adjust the height based on your needs
              width: 50,   // Adjust the width based on your needs
            ),
          ),
        ],
      ),
    );
  }
}
