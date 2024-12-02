import 'dart:async';
import 'package:e_shuttle/testingMap/timewithdistance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/directions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_shuttle/home/myProfile/myProfile.dart';
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

void main() => runApp(const LiveLocations());

class LiveLocations extends StatefulWidget {
  const LiveLocations({super.key});

  @override
  State<LiveLocations> createState() => _LiveLocationsState();
}

class RouteDetails {
  final LatLng driver_location;
  final LatLng startLocation;
  final LatLng endLocation;
  final List<LatLng> waypoints;

  RouteDetails({
    required this.driver_location,
    required this.startLocation,
    required this.endLocation,
    required this.waypoints,
  });
}

class _LiveLocationsState extends State<LiveLocations> {
  late Future<UserProfile> _userProfileFuture;
  bool _locationPermissionGranted = false;
  List<Map<String, dynamic>> _busStops = [];
  String? _selectedRouteId;

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
      _busStops = markersSnapshot.docs.map((doc) {
        var data = doc.data();
        GeoPoint geoPoint = data['coordinates'];
        return {
          'stopId': doc.id,
          'cityName': data['cityName'],
          'coordinates': LatLng(geoPoint.latitude, geoPoint.longitude),
          'estimatedArrivalTime': data['estimatedArrivalTime'] ?? 'N/A',
          'actualArrivalTime': data['actualArrivalTime'] ?? 'N/A',
        };
      }).toList();
    });
    print("Bus stops loaded: ${_busStops.length}");
  }

  Future<void> _calculateETAsForStops() async {
    if (_routeDetails == null) {
      print("Route details not available yet.");
      return;
    }

    if (_busStops.isEmpty) {
      print("Error: No bus stops available.");
      return;
    }

    final driverLocation = _routeDetails!.driver_location;

    // Sort stops by their distance to the driver
    _busStops.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        driverLocation.latitude,
        driverLocation.longitude,
        a['coordinates'].latitude,
        a['coordinates'].longitude,
      );
      final distanceB = Geolocator.distanceBetween(
        driverLocation.latitude,
        driverLocation.longitude,
        b['coordinates'].latitude,
        b['coordinates'].longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    // Filter stops that need ETA calculation (not passed yet)
    final upcomingStops = _busStops.where((stop) => stop['actualArrivalTime'] == 'N/A').toList();

    if (upcomingStops.isEmpty) {
      print("No upcoming stops to calculate ETAs.");
      return;
    }

    // Construct destinations for Distance Matrix API
    String destinations = upcomingStops
        .map((stop) => '${stop['coordinates'].latitude},${stop['coordinates'].longitude}')
        .join('|');

    if (destinations.isEmpty) {
      print("No valid destinations for ETA calculation.");
      return;
    }

    // Build API URL
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${driverLocation.latitude},${driverLocation.longitude}&destinations=$destinations&key=AIzaSyBRDV8VbzhAJvMyfWuqpObUKGOFBZ_kcgs');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['rows'][0]['elements'];

        if (elements == null || elements.isEmpty) {
          print("Error: API returned no elements.");
          return;
        }

        // Process and update ETA for each stop
        for (int i = 0; i < elements.length; i++) {
          final stop = upcomingStops[i];
          final element = elements[i];

          if (element['status'] != 'OK') {
            print("Stop ${stop['cityName']} is unreachable.");
            continue;
          }

          final duration = element['duration']['text'];
          final stopId = stop['stopId'];

          // Update Firestore and state
          FirebaseFirestore.instance
              .collection('routes')
              .doc(_selectedRouteId)
              .collection('markers')
              .doc(stopId)
              .update({'estimatedArrivalTime': duration});

          setState(() {
            _busStops.firstWhere((s) => s['stopId'] == stopId)['estimatedArrivalTime'] = duration;
          });

          print("ETA for ${stop['cityName']}: $duration");
        }
      } else {
        print("Error fetching Distance Matrix API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error calculating ETAs: $e");
    }
  }




  void _updatePassedStops(LatLng driverLocation) {
    for (var stop in _busStops) {
      if (stop['actualArrivalTime'] == 'N/A') {
        final distance = Geolocator.distanceBetween(
          driverLocation.latitude,
          driverLocation.longitude,
          stop['coordinates'].latitude,
          stop['coordinates'].longitude,
        );
        if (distance < 50) { // Adjust threshold as needed
          final actualTime = DateFormat.jm().format(DateTime.now());

          // Update Firestore with actual time
          FirebaseFirestore.instance
              .collection('routes')
              .doc(_selectedRouteId)
              .collection('markers')
              .doc(stop['stopId'])
              .update({'actualArrivalTime': actualTime});

          setState(() {
            stop['actualArrivalTime'] = actualTime;
          });
        }
      }
    }
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
        _selectedRouteId = routeDoc.id;
        var data = routeDoc.data();

        if (data != null) {
          print("Route ID: ${routeDoc.id}");

          await _getMarkerDataFromRoute(routeDoc.id);

          // Use null-aware operators to safely access GeoPoint values
          GeoPoint? driverGeo = data['driver_location'] as GeoPoint?;
          GeoPoint? startGeo = data['startLocation'] as GeoPoint?;
          GeoPoint? endGeo = data['endLocation'] as GeoPoint?;

          if (startGeo != null && endGeo != null && driverGeo != null) {
            LatLng driverLocation = LatLng(driverGeo.latitude, driverGeo.longitude);
            LatLng start = LatLng(startGeo.latitude, startGeo.longitude);
            LatLng end = LatLng(endGeo.latitude, endGeo.longitude);

            List<LatLng> waypoints = (data['waypoints'] as List?)
                ?.map((wp) => LatLng(wp.latitude, wp.longitude))
                .toList() ?? [];

            print("Start: $start, End: $end, Waypoints: $waypoints");

            setState(() {
              _routeDetails = RouteDetails(
                driver_location: driverLocation,
                startLocation: start,
                endLocation: end,
                waypoints: waypoints,
              );
            });}
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
      final driverLatLng = LatLng(newPosition.latitude, newPosition.longitude);
      _updatePassedStops(driverLatLng);
      _calculateETAsForStops();
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
        appBar: AppBar(title: Text(
            _routeDetails != null
                ? 'Live Location: ${_routeDetails!.driver_location.latitude}, ${_routeDetails!.driver_location.longitude}'
                : 'Loading driver location...',
            ),
            leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute (builder: (context) => MyLiveRoute()),
                ); // Go back to the previous screen
            },
          ),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
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
          ..._busStops.map((stop) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stop['cityName'], style: TextStyle(fontSize: 16)),
                  stop['actualArrivalTime'] != 'N/A'
                      ? Text('Passed at ${stop['actualArrivalTime']}', style: TextStyle(fontSize: 16, color: Colors.green))
                      : Text('ETA: ${stop['estimatedArrivalTime']}', style: TextStyle(fontSize: 16, color: Colors.blue)),
                ],
              ),
            );
          }).toList(),
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
