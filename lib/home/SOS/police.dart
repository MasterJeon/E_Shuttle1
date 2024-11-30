import 'package:geolocator/geolocator.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';



class PoliceStation {
  final String name;
  final String address;
  final String phone;

  PoliceStation({required this.name, required this.address, required this.phone});

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
      name: json['name'] ?? 'Unknown police station',
      address: json['vicinity'] ?? 'No address available',
      phone: json.containsKey('formatted_phone_number') ? json['formatted_phone_number'] : 'No phone available',
    );
  }
}


void main() {
  runApp( PoliceStationPageApp());
}

class PoliceStationPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(
        //primarySwatch: Colors.indigo,
      //),
      home: PoliceStationPage(),
    );
  }
}


class PoliceStationPage extends StatefulWidget {
  @override
  _PoliceStationPageState createState() => _PoliceStationPageState();
}

class _PoliceStationPageState extends State<PoliceStationPage> {
  Position? _currentPosition;
  List<PoliceStation> _policeStations = [];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission().then((_) {
      _getCurrentLocation().then((position) {
        _getNearbyPoliceStations(position).then((stations) {
          setState(() {
            _currentPosition = position;
            _policeStations = stations;
          });
        });
      });
    });
  }

  Future<void> _getUserLocation() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  setState(() {
    _currentPosition = position;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Police Stations'),
        centerTitle: true,
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
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : _policeStations.isEmpty
              ? Center(child: Text('No police stations found in your area.'))
              : ListView.builder(
                  itemCount: _policeStations.length,
                  itemBuilder: (context, index) {
                    final station = _policeStations[index];
                    return ListTile(
                      title: Text(station.name),
                      subtitle: Text(station.address),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (station.phone != 'No phone available') {
                            FlutterPhoneDirectCaller.callNumber(station.phone);
                          }
                        },
                        child: Text('Call'),
                      ),
                    );
                  },
                ),
    );
  }
}


Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    // Handle permission denial here (e.g., show a message or redirect)
  }
}

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  // Check for location permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  // Get current position
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

Future<List<PoliceStation>> _getNearbyPoliceStations(Position position) async {
  String apiKey = 'AIzaSyBRDV8VbzhAJvMyfWuqpObUKGOFBZ_kcgs';
  String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
               '?location=${position.latitude},${position.longitude}&radius=10000'
               '&type=police&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    print(jsonResponse);  // Print the entire response to check the results
    return (jsonResponse['results'] as List).map((json) => PoliceStation.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load police stations');
  }
}