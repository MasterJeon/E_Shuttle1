import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(6.81750000, 79.89027778);
  
  void _onMapCreated(GoogleMapController controller){
    mapController = controller; 
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps in Flutter'),
          //backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0
            ),
            markers: {
              const Marker(
                markerId: MarkerId('KDU'),
                position: LatLng(6.817801415099614, 79.89069891600366),
                infoWindow: InfoWindow(title: "KDU")
              ),
              createMarker('Panadura', const LatLng(6.7104892147864605, 79.90773987399923),"120.00"),
              createMarker('Bandaragama', const LatLng(6.714151106845103, 79.99073558146642),"180.00"),
              createMarker('Horana', const LatLng(6.723170703502162, 80.06583043717407),"220.00"),
              createMarker('Piliyandala', const LatLng(6.801664896754592, 79.92279155884555),"60.00"),
              createMarker('Kottawa', const LatLng(6.841110311554549, 79.96538119310712),"150.00"),
              createMarker('Godagama', const LatLng(6.851902488708469, 80.03334731284404),"200.00"),
              createMarker('Pahathgama', const LatLng(6.896416594616102, 80.08231467508558),"250.00"),
              createMarker('Maharagama', const LatLng(6.850763264031758, 79.92749206117588),"70.00"),
              createMarker('Koswatta', const LatLng(6.908986729283659, 79.93080459154916),"120.00"),
              createMarker('Kaduwela', const LatLng(6.928927044316318, 79.9826355994138),"160.00"),
              createMarker('Delgoda', const LatLng(6.988008813288438, 80.0159422824388),"200.00"),
              createMarker('Weliweriya', const LatLng(7.0319529504541665, 80.02978339087662),"220.00"),
              createMarker('Yakkala', const LatLng(7.086412609614552, 80.03433536285229),"260.00"),
              createMarker('Nittambuwa', const LatLng(7.142191208759358, 80.10636908834084),"300.00"),
              createMarker('Kesbewa', const LatLng(6.7781983860413995, 79.9476704429502),"60.00"),
              createMarker('Polgasowita/Kindelpitiya', const LatLng(6.788272881361812, 79.99172337450369),"110.00"),
              createMarker('Gonapola/Gammanpila', const LatLng(6.755930079059569, 80.0166182135967),"150.00"),
              createMarker('Kumbuka/Bandaragama', const LatLng(6.736008281612015, 80.02806926808988),"170.00"),
              createMarker('Pokunuwita', const LatLng(6.72902450012628, 80.03227120891174),"190.00"),
              createMarker('Aththidiya', const LatLng(6.8397971035243135, 79.88561675594863),"40.00"),
              createMarker('Nugegoda', const LatLng(6.865207771841957, 79.89794010974578),"70.00"),
              createMarker('Peliyagoda', const LatLng(6.9589941781914835, 79.89336981001003),"170.00"),
              createMarker('Ja-Ela', const LatLng(7.067703587465936, 79.90154521053142),"250.00"),
              createMarker('Negambo', const LatLng(7.207330829673679, 79.85258837399863),"290.00"),
          },
        )
      ),
    );
  }
  Marker createMarker(String markerId, LatLng position, String price) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId, snippet: "Ticket price: Rs."+price),
      icon: BitmapDescriptor.defaultMarker,
    );
  }

}
