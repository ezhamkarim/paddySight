import 'package:final_year_die/screens/authenticate/registerMaps.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'dart:async';
import 'package:location/location.dart';

class SelectMaps extends StatefulWidget {
  @override
  _SelectMapsState createState() => _SelectMapsState();
}

class _SelectMapsState extends State<SelectMaps> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _checkLocationPermision();
  }

  Future<LocationData> _checkLocationPermision() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return _locationData = await location.getLocation();
  }

  @override
  Widget build(context) {
    return FutureBuilder<LocationData>(
        future: _checkLocationPermision(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RegisterMaps(
              location: snapshot.data,
            );
          } else {
            return Loading();
          }
        }); // doesn't work either
  }

  // if(_locationData!=null){
  //   return RegisterMaps(location:_locationData);
  // }
  // else{
  //   return Scaffold();
  // }

  // return MaterialApp(

  //   home: RaisedButton(onPressed:
  //   (){
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>
  //   RegisterMaps(location: _locationData)

  // ));
  //   }
  //   ,child: Text('Hai'),
  //   ),
  // );

}
