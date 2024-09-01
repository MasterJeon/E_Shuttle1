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
            zoom: 9.0
            ),
            markers:{
              const Marker(
                markerId: MarkerId('KDU'),
                position: LatLng(6.817737497282897, 79.89141774801097),
              ),
              const Marker(
                markerId: MarkerId('Panadura'),
                position: LatLng(6.7104892147864605, 79.90773987399923),
              ),
              const Marker(
                markerId: MarkerId('Bandaragama'),
                position: LatLng(6.714151106845103, 79.99073558146642),
              ),
              const Marker(
                markerId: MarkerId('Horana'),
                position: LatLng(6.723170703502162, 80.06583043717407),
              ),
              const Marker(
                markerId: MarkerId('Piliyandala'),
                position: LatLng(6.801664896754592, 79.92279155884555),
              ),
              const Marker(
                markerId: MarkerId('Kottawa'),
                position: LatLng(6.841110311554549, 79.96538119310712),
              ),
              const Marker(
                markerId: MarkerId('Godagama'),
                position: LatLng(6.851902488708469, 80.03334731284404),
              ),
              const Marker(
                markerId: MarkerId('Pahathgama'),
                position: LatLng(6.896416594616102, 80.08231467508558),
              ),
              const Marker(
                markerId: MarkerId('Maharagama'),
                position: LatLng(6.850763264031758, 79.92749206117588),
              ),
              const Marker(
                markerId: MarkerId('Koswatta'),
                position: LatLng(6.908986729283659, 79.93080459154916),
              ),
              const Marker(
                markerId: MarkerId('Kaduwela'),
                position: LatLng(6.928927044316318, 79.9826355994138),
              ),
              const Marker(
                markerId: MarkerId('Delgoda'),
                position: LatLng(6.988008813288438, 80.0159422824388),
              ),
              const Marker(
                markerId: MarkerId('Weliweriya'),
                position: LatLng(7.0319529504541665, 80.02978339087662),
              ),
              const Marker(
                markerId: MarkerId('Yakkala'),
                position: LatLng(7.086412609614552, 80.03433536285229),
              ),
              const Marker(
                markerId: MarkerId('Nittambuwa'),
                position: LatLng(7.142191208759358, 80.10636908834084),
              ),
              const Marker(
                markerId: MarkerId('Kesbewa'),
                position: LatLng(6.7781983860413995, 79.9476704429502),
              ),
              const Marker(
                markerId: MarkerId('Polgasowita/Kindelpitiya'),
                position: LatLng(6.788272881361812, 79.99172337450369),
              ),
              const Marker(
                markerId: MarkerId('Gonapola/Gammanpila'),
                position: LatLng(6.755930079059569, 80.0166182135967),
              ),
              const Marker(
                markerId: MarkerId('Kumbuka/Bandaragama'),
                position: LatLng(6.736008281612015, 80.02806926808988),
              ),
              const Marker(
                markerId: MarkerId('Pokunuwita'),
                position: LatLng(6.72902450012628, 80.03227120891174),
              ),
              const Marker(
                markerId: MarkerId('Aththidiya'),
                position: LatLng(6.8397971035243135, 79.88561675594863),
              ),
              const Marker(
                markerId: MarkerId('Nugegoda'),
                position: LatLng(6.865207771841957, 79.89794010974578),
              ),
              const Marker(
                markerId: MarkerId('Peliyagoda'),
                position: LatLng(6.9589941781914835, 79.89336981001003),
              ),
              const Marker(
                markerId: MarkerId('Ja-Ela'),
                position: LatLng(7.067703587465936, 79.90154521053142),
              ),
              const Marker(
                markerId: MarkerId('Negambo'),
                position: LatLng(7.207330829673679, 79.85258837399863),
              ),
            }
        )
      ),
    );
  }
}
