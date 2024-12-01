import 'package:geolocator/geolocator.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';


// Hospital class declaration (ensure this is placed before _HospitalPageState)
class Hospital {
  final String name;
  final String address;
  final String phone;

  Hospital({required this.name, required this.address, required this.phone});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'] ?? 'Unknown hospital',
      address: json['vicinity'] ?? 'No address available',
      phone: json.containsKey('formatted_phone_number') ? json['formatted_phone_number'] : 'No phone available',
      
    );
  }
}

void main() {
  runApp( HospitalPageApp());
}

class HospitalPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(
        //primarySwatch: Colors.indigo,
      //),
      home: HospitalPage(),
    );
  }
}

class HospitalPage extends StatefulWidget {
  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  Position? _currentPosition;
  List<Hospital> _hospitals = [];

@override
void initState() {
  super.initState();
  _requestLocationPermission().then((_) {
    _getCurrentLocation().then((position) {
      _getNearbyHospitals(position).then((hospitals) {
        setState(() {
          _currentPosition = position;
          _hospitals = hospitals;
        });
      });
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Hospitals'),
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
        ), //
      ),
body: _currentPosition == null
    ? Center(child: CircularProgressIndicator())
    : _hospitals.isEmpty
        ? Center(child: Text('No hospitals found in your area.'))
        : ListView.builder(
            itemCount: _hospitals.length,
            itemBuilder: (context, index) {
              final hospital = _hospitals[index];
              return ListTile(
                title: Text(hospital.name),
                subtitle: Text(hospital.address),
                trailing: ElevatedButton(
                  onPressed: () {
                    if (hospital.phone != 'No phone available') {
                      FlutterPhoneDirectCaller.callNumber(hospital.phone);
                    }
                  },
                  child: Text('Call'),
                ),
              );
            },
          ),
    );
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


Future<void> _getUserLocation() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  setState(() {
    _currentPosition = position;
  });
}

Future<List<Hospital>> _getNearbyHospitals(Position position) async {
  String apiKey = 'AIzaSyDRjUOF4SaputIfu2RO7pyFMJ9m9SbWtyE';
  String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
               '?location=${position.latitude},${position.longitude}&radius=10000'  //change the radius of the search area
               '&type=hospital&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    print(jsonResponse);  // Print the entire response to check the results in the debug console
    return (jsonResponse['results'] as List).map((json) => Hospital.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load hospitals');
  }
}
}