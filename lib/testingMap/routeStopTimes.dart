import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/directions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_shuttle/home/myProfile/myProfile.dart';

void main() => runApp(const LiveLocation());

class LiveLocation extends StatefulWidget {
  const LiveLocation({super.key});

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class RouteDetails {
  final String startLocation;
  final String endLocation;
  final List<String> waypoints;

  RouteDetails({
    required this.startLocation,
    required this.endLocation,
    required this.waypoints,
  });
}

class _LiveLocationState extends State<LiveLocation> {
  late Future<UserProfile> _userProfileFuture;
  bool _locationPermissionGranted = false;

  // Location stream subscription
  StreamSubscription<Position>? _positionStreamSubscription;

  // Variables for live location
  String _liveLocation = "Fetching..."; //must be updated real time

  String departureLocation = "Kottawa";
  String arrivalLocation = "KDU";
  String departureTime = "6:00 AM"; 
  String arrivalTime = "8:00 AM"; //must be updated real time
  String distance = "39 km";
  String duration = "1h 26min";

  // Bus stops and times
  final List<Map<String, String>> busStops = [
    {"stop": "Pahathgama", "time": "6:34 AM"},
    {"stop": "Godagama", "time": "6:57 AM"},
    {"stop": "Kottawa", "time": "7:16 AM"},
    {"stop": "Piliyandala", "time": "7:41 AM"},
    {"stop": "KDU", "time": "8:00 AM"},
  ];

  RouteDetails? _routeDetails;

  @override
  void initState() {
    super.initState();
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
        .doc(routeId)
        .collection('markers')
        .get();

    print("Total markers fetched for route $routeId: ${markersSnapshot.docs.length}");

    setState(() {
      for (var doc in markersSnapshot.docs) {
        var data = doc.data();
        GeoPoint geoPoint = data['coordinates'];
        // Handle geoPoint data here if needed
      }
    });
  }

  Future<void> _getRouteDataFromDB() async {
    final userProfile = await _fetchUserProfile();
    final selectedRouteNumber = userProfile.routeno;

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

          String startLocation = data['startLocation'] ?? "Unknown Start Location";
          String endLocation = data['endLocation'] ?? "Unknown End Location";
          List<String> waypoints = List<String>.from(data['waypoints'] ?? []);

          setState(() {
            _routeDetails = RouteDetails(
              startLocation: startLocation,
              endLocation: endLocation,
              waypoints: waypoints,
            );
          });
        }
      }
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
      _liveLocation = "Lat: ${position.latitude}, Lng: ${position.longitude}";
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Live Location: $_liveLocation'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: 
              journeyDetail(departureLocation, departureTime, distance, duration, arrivalLocation, arrivalTime),
           ),
           Padding(
            padding: const EdgeInsets.all(10.0),
            child: stopsTime(),
          ),
         ],
       ),
      ),
    );
  }
  Widget journeyDetail(String departureLocation, String departureTime, String distance, String duration, String arrivalLocation, String arrivalTime) {
    return Container(
      width: 350,  // Set desired width here
      height: 120, // Set desired height here
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 37, 137, 232),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Departure Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Departure",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                departureTime,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                departureLocation,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          // Distance and Duration
          Column(
              children: [
                Text(
                  distance,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Row(
              children: [
                Text(
                  '-   -   -   -   -   -', // Replace with desired number of dashes
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(width: 8), // Space between dashes and arrow
                Icon(
                  Icons.arrow_forward, // Arrow icon between Departure and Arrival
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                  ],
                ), // Space between arrow and duration
                Text(
                  duration,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          // Arrival Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Arrival",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                arrivalTime,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                arrivalLocation,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
  

  Widget stopsTime() {
    return Container(
      width: 350,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bus Route", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 10),
          ...busStops.map((stop) => _buildStopTimeRow(stop["stop"]!, stop["time"]!)).toList(),
        ],
      ),
    );
  }

  Widget _buildStopTimeRow(String stop, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(stop, style: TextStyle(fontSize: 16)),
          Text(time, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

