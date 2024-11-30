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
  runApp(PoliceStationPageApp());
}

class PoliceStationPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearest Police Stations',
      debugShowCheckedModeBanner: false,
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _requestLocationPermission();
      final position = await _getCurrentLocation();
      final stations = await _getNearbyPoliceStations(position);

      setState(() {
        _currentPosition = position;
        _policeStations = stations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are denied');
    }
  }

  Future<Position> _getCurrentLocation() async {
    print('Fetching current location...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are denied.');
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Current location: $position');
    return position;
  }

  Future<List<PoliceStation>> _getNearbyPoliceStations(Position position) async {
    print('Fetching police stations...');
    String apiKey = 'AIzaSyDRjUOF4SaputIfu2RO7pyFMJ9m9SbWtyE';
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=10000&type=police&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    print('API response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('API response: ${response.body}');

      if (jsonResponse['results'] != null) {
        return (jsonResponse['results'] as List)
            .map((json) => PoliceStation.fromJson(json))
            .toList();
      } else {
        print('No results found in API response.');
        return [];
      }
    } else {
      throw Exception('Failed to fetch police stations: ${response.body}');
    }
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Could not fetch location.', style: TextStyle(fontSize: 16)),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _policeStations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No police stations found in your area.', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: _fetchData,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
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
