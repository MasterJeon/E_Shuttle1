import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyRoute());

class MyRoute extends StatefulWidget {
  const MyRoute({super.key});

  @override
  State<MyRoute> createState() => _MyRouteState();
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

class _MyRouteState extends State<MyRoute> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(6.81750000, 79.89027778);

  // To store user's current position
  LatLng _currentPosition = LatLng(6.81750000, 79.89027778);
  final Set<Marker> _markers = {};
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

  final List<RouteDetails> _routes = [
    
    RouteDetails(
      startLocation: LatLng(6.81750000, 79.89027778),
      endLocation: LatLng(6.723170703502162, 80.06583043717407),
      waypoints: [
        LatLng(6.710187124161938, 79.90792773892063),
        LatLng(6.713937790150642, 79.98895190786376),
      ],
    ),
    RouteDetails(
      startLocation: LatLng(6.81750000, 79.89027778),
      endLocation: LatLng(6.858558825786435, 80.09127959618279),
      waypoints: [
        LatLng(6.816251778070154, 79.90076773256791),
        LatLng(6.825356560245373, 79.90729266469265),
        LatLng(6.80546082616985, 79.92633783071939),
      ],
    ),
    RouteDetails(
      startLocation: LatLng(6.81750000, 79.89027778),
      endLocation: LatLng(7.140999095293039, 80.0940343340502),
      waypoints: [
        LatLng(6.816251778070154, 79.90076773256791),
        LatLng(6.825356560245373, 79.90729266469265),
        LatLng(6.841157566076842, 79.90258850786502),
        LatLng(6.8475074321400395, 79.92684536855644),
        LatLng(6.9073562249883995, 79.93205484777869),
        LatLng(6.929096638160336, 79.9827753536656),
        LatLng(6.990469786485393, 80.01507697617508),
        LatLng(7.031678090285276, 80.02916747125509),
        LatLng(7.086972685701563, 80.0316414091988),
      ],
    ),
    RouteDetails(
      startLocation: LatLng(6.81750000, 79.89027778),
      endLocation: LatLng(6.7260981347864925, 80.03444020794345),
      waypoints: [
        LatLng(6.801683003645485, 79.92284226523292),
        LatLng(6.784431719653115, 79.97820705905943),
        LatLng(6.754860677381756, 80.01516740570327),
        LatLng(6.735410206202415, 80.02831908725203),
      ],
    ),
    RouteDetails(
      startLocation: LatLng(6.81750000, 79.89027778),
      endLocation: LatLng(7.2058542889936605, 79.85043375277819),
      waypoints: [
        LatLng(6.8395726845980915, 79.88464910194882),
        LatLng(6.863026997578493, 79.9014690823925),
        LatLng(6.966050944792678, 79.88248543320111),
        LatLng(7.048889353862322, 79.89663825680438),
        LatLng(7.122930382401751, 79.87847497123519),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getRoute();
    _requestLocationPermission();
  }

  void _getRoute() async {
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
  }

  Future<void> _getDistanceMatrix(RouteDetails route, int routeIndex) async {
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
      _markers.add(
        Marker(
          markerId: const MarkerId('userLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );

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
              markers: _createMarkers(),
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
      createMarker('Panadura', const LatLng(6.7104892147864605, 79.90773987399923), "120.00"),
      createMarker('Bandaragama', const LatLng(6.714151106845103, 79.99073558146642), "180.00"),
      createMarker('Horana', const LatLng(6.723170703502162, 80.06583043717407), "220.00"),
      createMarker('Piliyandala', const LatLng(6.801664896754592, 79.92279155884555), "60.00"),
      createMarker('Kottawa', const LatLng(6.841110311554549, 79.96538119310712), "150.00"),
      createMarker('Godagama', const LatLng(6.851902488708469, 80.03334731284404), "200.00"),
      createMarker('Pahathgama', const LatLng(6.896416594616102, 80.08231467508558), "250.00"),
      createMarker('Maharagama', const LatLng(6.850763264031758, 79.92749206117588), "70.00"),
      createMarker('Koswatta', const LatLng(6.908986729283659, 79.93080459154916), "120.00"),
      createMarker('Kaduwela', const LatLng(6.928927044316318, 79.9826355994138), "160.00"),
      createMarker('Delgoda', const LatLng(6.988008813288438, 80.0159422824388), "200.00"),
      createMarker('Weliweriya', const LatLng(7.0319529504541665, 80.02978339087662), "220.00"),
      createMarker('Yakkala', const LatLng(7.086412609614552, 80.03433536285229), "260.00"),
      createMarker('Nittambuwa', const LatLng(7.142191208759358, 80.10636908834084), "300.00"),
      createMarker('Kesbewa', const LatLng(6.7781983860413995, 79.9476704429502), "60.00"),
      createMarker('Polgasowita/Kindelpitiya', const LatLng(6.788272881361812, 79.99172337450369), "110.00"),
      createMarker('Gonapola/Gammanpila', const LatLng(6.755930079059569, 80.0166182135967), "150.00"),
      createMarker('Kumbuka/Bandaragama', const LatLng(6.736008281612015, 80.02806926808988), "170.00"),
      createMarker('Pokunuwita', const LatLng(6.72902450012628, 80.03227120891174), "190.00"),
      createMarker('Aththidiya', const LatLng(6.8397971035243135, 79.88561675594863), "40.00"),
      createMarker('Nugegoda', const LatLng(6.865207771841957, 79.89794010974578), "70.00"),
      createMarker('Peliyagoda', const LatLng(6.9589941781914835, 79.89336981001003), "170.00"),
      createMarker('Ja-Ela', const LatLng(7.067703587465936, 79.90154521053142), "250.00"),
      createMarker('Negambo', const LatLng(7.207330829673679, 79.85258837399863), "290.00"),
    };
  }

  Marker createMarker(String markerId, LatLng position, String price) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId, snippet: "Ticket price: Rs." + price),
      icon: BitmapDescriptor.defaultMarker,
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
            padding: const EdgeInsets.only(left: 10.0), // Increased left padding
            child: Icon(Icons.person_pin_circle_rounded, size: 40, color: Colors.blue),
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
