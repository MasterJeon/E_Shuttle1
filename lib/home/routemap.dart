import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const RouteMapPage());

Future<List<Map<String, dynamic>>> getRouteData(String routeId) async {
  CollectionReference routes = FirebaseFirestore.instance.collection('routes');
  DocumentSnapshot routeDoc = await routes.doc(routeId).get();

  if (routeDoc.exists) {
    Map<String, dynamic> citiesData = routeDoc.data() as Map<String, dynamic>;

    // Iterate over each city in the document
    return citiesData.entries.map((entry) {
      String cityName = entry.key;  // City name as key
      GeoPoint location = entry.value['latlong'];  // GeoPoint
      double ticketPrice = entry.value['ticket_price'];  // Ticket price

      return {
        'location': location,
        'name': cityName,
        'ticket_value': ticketPrice
      };
    }).toList();
  } else {
    throw Exception('Route does not exist');
  }
}


class RouteMapPage extends StatefulWidget {
  const RouteMapPage({Key? key}) : super(key: key);
  //final String routeId;

  //RouteMapPage({required this.routeId});

  @override
  _RouteMapPageState createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  GoogleMapController? _mapController;
  List<Marker> _markers = [];
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _loadRouteData();
  }

  Future<void> _loadRouteData() async {
    // Replace 'r1' with the selected route document dynamically
    DocumentSnapshot<Map<String, dynamic>> routeDoc =
    await FirebaseFirestore.instance.collection('routes').doc('r1').get();

    if (routeDoc.exists) {
      // Loop through each city field in the document
      routeDoc.data()?.forEach((cityName, cityArray) {
        if (cityArray is List && cityArray.length >= 3) {
          // Extract city details from the array
          String name = cityArray[0]; // City name (e.g., "Panadura")
          GeoPoint geopoint = cityArray[1]; // GeoPoint (latitude, longitude)
          double ticketValue = cityArray[2]; // Ticket price

          LatLng position = LatLng(geopoint.latitude, geopoint.longitude);

          setState(() {
            // Add marker for each city
            _markers.add(
              Marker(
                markerId: MarkerId(name),
                position: position,
                infoWindow: InfoWindow(
                  title: name,
                  snippet: 'Ticket: \$${ticketValue.toStringAsFixed(2)}',
                ),
              ),
            );

            // Add to polyline coordinates for drawing route
            _polylineCoordinates.add(position);
          });
        }
      });

      // Add the polyline connecting the cities
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route_polyline'),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(6.81750000, 79.89027778),  // Default center
          zoom: 8,
        ),
        markers: Set.from(_markers),
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
