import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';



void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  Completer<GoogleMapController> mapController = Completer();

  MapType _currentMapType = MapType.normal;
   LatLng _lastMapPosition;

  Position _currentPosition;

  String _address;

  void _onToggleMapTypePressed() {
    final MapType nextType =
        MapType.values[(_currentMapType.index + 1) % MapType.values.length];

    setState(() => _currentMapType = nextType);
  }

  Future<void> _initCurrentLocation() async {
    Position currentPosition;
    try {
      currentPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      print("position = $currentPosition");

      setState(() => _currentPosition = currentPosition);
    } on PlatformException catch (e) {
      currentPosition = null;
      print("_initCurrentLocation#e = $e");
    }

    if (!mounted) return;

    setState(() => _currentPosition = currentPosition);

    if (currentPosition != null)
          LatLng(currentPosition.latitude, currentPosition.longitude);
  }
   @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Testing_3 App'),
          backgroundColor: Colors.green[700],
        ),
         body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: GoogleMap(
                     onMapCreated: (GoogleMapController controller) {
                      mapController.complete(controller);
                      },
                    initialCameraPosition: CameraPosition(
                      target: ,
                      zoom: 11.0,
                    ),
                  ),
                )
              ), // THIS ONE U LESS ONE BACKET
              Container(
                height: 200,
                child: Card(
                  child: new Form(
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new TextFormField(
                            decoration: new InputDecoration(labelText: "FROM"),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new TextFormField(
                            decoration: new InputDecoration(labelText: "DESTINATION"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}