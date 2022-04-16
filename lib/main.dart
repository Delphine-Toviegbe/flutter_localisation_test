//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Google Maps Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   static const cotonou=LatLng(6.4106831, 2.3439799);
   static const paris=LatLng(6.4106831, 2.3439799);
   Location location=Location();
   bool _serviceEnabled = true;
   _checkPermission()async{
     PermissionStatus _permissionGranted;
     LocationData _locationData;
     _serviceEnabled = await location.requestService();
     if (!_serviceEnabled) {
       _serviceEnabled = await location.requestService();
       if (!_serviceEnabled) {
         return;
       }
     }

     _permissionGranted = await location.hasPermission();
     if (_permissionGranted == PermissionStatus.denied) {
       _permissionGranted = await location.requestPermission();
       if (_permissionGranted != PermissionStatus.granted) {
         return;
       }
     }
     _locationData = await location.getLocation();
   }

   Marker _cotonouMarker = Marker(
       markerId: const MarkerId("cotonou"),
      infoWindow: const InfoWindow(title: 'Cotonou'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
     position: cotonou,
   );
   Marker _parisMarker = Marker(
       markerId: const MarkerId("paris"),
       infoWindow: const InfoWindow(title: 'Paris'),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
       position: paris,
   );
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("Localisation");
      print(currentLocation);
    });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
              child: GoogleMap(
                zoomControlsEnabled: true,
                mapType: MapType.satellite,
                markers: {
                  _cotonouMarker,
                  _parisMarker
                },
                initialCameraPosition: CameraPosition(
                  target:LatLng(6.4106831, 2.3439799),
                  zoom: 17
                ),
                onMapCreated: (GoogleMapController controller){

                },

              )
          )
        ],
      ),
    );
  }
}
