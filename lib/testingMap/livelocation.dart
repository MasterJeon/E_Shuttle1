import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
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
  final LatLng startLocation;
  final LatLng endLocation;
  final List<LatLng> waypoints;

  RouteDetails({
    required this.startLocation,
    required this.endLocation,
    required this.waypoints,
  });
}


class _LiveLocationState extends State<LiveLocation> {
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


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /*final List<RouteDetails> _routes = [
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
  ];*/

  @override
  void initState() {
    super.initState();
    //_getRoute();
    _markers.addAll(_createMarkers());
    _getRouteDataFromDB();
    //_getMarkerDataFromDB();
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


        /*_markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: position,
            infoWindow: InfoWindow(
              title: data['cityName'],
              snippet: "Ticket price: Rs." + data['ticketPrice'].toString(),
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );*/
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
        body: GoogleMap(
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
      //createMarker('Panadura', const LatLng(6.7104892147864605, 79.90773987399923), "120.00"),
      //createMarker('Bandaragama', const LatLng(6.714151106845103, 79.99073558146642), "180.00"),
      //createMarker('Horana', const LatLng(6.723170703502162, 80.06583043717407), "220.00"),
      //createMarker('Piliyandala', const LatLng(6.801664896754592, 79.92279155884555), "60.00"),
      /*createMarker('Kottawa', const LatLng(6.841110311554549, 79.96538119310712), "150.00"),
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
      createMarker('Negambo', const LatLng(7.207330829673679, 79.85258837399863), "290.00"),*/
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
