import 'dart:collection';
import 'dart:convert';
import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/shared/last_icon_final_icons.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/screens/home/home.dart';
import 'package:final_year_die/models/firstTime.dart';
import 'package:final_year_die/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/models/polygon.dart';
import 'package:http/http.dart' as http;
import 'package:final_year_die/shared/constant.dart';
import 'package:geocoder/geocoder.dart';

Future<PolygonData> createPolygon(
    Map<String, dynamic> polygonCoors, String polygonTitle) async {
  final http.Response response = await http.post(
      'http://api.agromonitoring.com/agro/1.0/polygons?appid=$apiKey',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{"name": polygonTitle, "geo_json": polygonCoors}));

  if (response.statusCode == 201) {
    print("Berjaya");
    return PolygonData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create polygon.');
  }
}

class RegisterMaps extends StatefulWidget {
  final LocationData location;

  RegisterMaps({this.location});
  @override
  _RegisterMapsState createState() => _RegisterMapsState();
}

class _RegisterMapsState extends State<RegisterMaps> {
  LocationData _locationData;
  bool loading = false;

  Set<Polygon> _polygon = HashSet<Polygon>();

  List<LatLng> polygonLatLngs = List<LatLng>();
  List<List> geoPoints = List<List>();
  List<List<List>> geoCoordinate = List<List<List>>();
  double radius;
  final _kunciForm = GlobalKey<FormState>();

  Map<String, dynamic> geoJson;

  String inputPolygonName;

  String id;
  double area;
  String polygonNama;
  String geoJsonDatabase;

  int _polygonIdCounter = 1;

  bool _isPolygon = true;

  @override
  void initState() {
    _locationData = widget.location;
    super.initState();
  }

  void showSimpleCustomDialog(BuildContext context, String text) {
    AlertDialog simpleDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      content: Container(
        height: 150.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Okay'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  void showInputDialog(BuildContext context) {
    AlertDialog simpleDialog = AlertDialog(
      title: Text(getTranslated(context, 'polygon_name')),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 60,
        child: Form(
          key: _kunciForm,
          child: Column(
            children: <Widget>[
              TextFormField(
                cursorColor: Colors.yellow,
                decoration: textInputDecoration.copyWith(
                    hintText: getTranslated(context, 'polygon_name_hint')),
                validator: (val) => val.isEmpty
                    ? getTranslated(context, 'polygon_name_error')
                    : null,
                onChanged: (value) {
                  setState(() {
                    inputPolygonName = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Okay'),
          onPressed: () {
            if (_kunciForm.currentState.validate()) {
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );

    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygon.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        strokeColor: Colors.yellow,
        fillColor: Colors.yellow.withOpacity(0.5)));
    print("Lang and Lat of polygon " + polygonLatLngs.toString());
  }

  @override
  Widget build(BuildContext context) {
    //final polyData = Provider.of<PolygonData>(context);
    final firstTime = Provider.of<FirstTime>(context);
    final pengguna = Provider.of<User>(context);
    if (firstTime.getPilihMaps) {
      //print('HAII NI ID' +id);
      return Home(polyID: id);
    } else
      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target:
                      LatLng(_locationData.latitude, _locationData.longitude),
                  zoom: 16),
              mapType: MapType.hybrid,
              polygons: _polygon,
              myLocationEnabled: true,
              onTap: (point) {
                if (_isPolygon) {
                  setState(() {
                    polygonLatLngs.add(point);
                    _setPolygon();
                  });
                }
              },
            ),
            Positioned(
              left: 10.0,
              bottom: 30.0,
              child: Column(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 60,
                    height: 60,
                    child: RaisedButton(
                      shape: CircleBorder(),
                      color: Colors.black54,
                      onPressed: () {
                        showInputDialog(context);
                        _isPolygon = true;

                        print('Polygon is ' + _isPolygon.toString());
                      },
                      child: Icon(
                        LastIconFinal.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    minWidth: 60,
                    height: 60,
                    child: RaisedButton(
                      shape: CircleBorder(),
                      color: Colors.black54,
                      onPressed: () {
                        polygonLatLngs.clear();
                        _polygon.clear();
                        print('Polygon is ' + _isPolygon.toString());
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.grey,
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 40,
                        )),
                    onTap: () async {
                      if (polygonLatLngs.length == 0) {
                        return showSimpleCustomDialog(
                            context, getTranslated(context, 'draw_poly'));
                      } else {
                        polygonLatLngs.add(polygonLatLngs[0]);
                        for (int i = 0; i < polygonLatLngs.length; i++) {
                          print(polygonLatLngs.length.toString());
                          List geoPoint = [
                            polygonLatLngs[i].longitude,
                            polygonLatLngs[i].latitude
                          ];
                          geoPoints.add(geoPoint);
                        }

                        geoCoordinate.add(geoPoints);

                        geoJson = {
                          "type": "Feature",
                          "properties": {},
                          "geometry": {
                            "type": "Polygon",
                            "coordinates": geoCoordinate
                          }
                        };
                        //polygonRegister which is type of future<void> store and setstate the value of string id to the object return by createPolygon

                        final coordinates = new Coordinates(
                            polygonLatLngs[0].latitude,
                            polygonLatLngs[0].longitude);
                        var addresses = await Geocoder.local
                            .findAddressesFromCoordinates(coordinates);
                        var first = addresses.first;

                        createPolygon(geoJson, inputPolygonName)
                            .then((PolygonData onValue) {
                          setState(() {
                            id = onValue.polygonID;
                            polygonNama = onValue.polygonName;
                            area = onValue.area;
                            geoJsonDatabase = onValue.geojsonCoors.toString();

                            DatabaseService(uid: pengguna.uid).tambahPolyData(
                                id, polygonNama, area, geoJsonDatabase);
                            DatabaseService(uid: pengguna.uid)
                                .tambahFirstAccount();
                            DatabaseService(uid: pengguna.uid)
                                .tambahFirstInventory();
                            DatabaseService(uid: pengguna.uid)
                                .tambahFirstSatelliteImage();
                          });
                        });
                        //print('HAII NI ID' +id);
                        // polyData.setComplete(true);

                        //polyData.fetchData(geoJson, 'Suka Hati');

                        // print('HAIII GEOPOINTS NI   ' +
                        //     geoPoints.toList().toString());
                        // print('HAIII GEOPOINTS NI' +
                        //     geoCoordinate.toList().toString());
                        firstTime.setPilihMaps(true);
                        DatabaseService(uid: pengguna.uid).tambahUserData(
                            polygonLatLngs.toList().toString(),
                            polygonLatLngs[0].latitude.toString(),
                            polygonLatLngs[0].longitude.toString(),
                            first.subLocality);
                      }
                    },
                  ),
                ),
              ),
              // child: ClipOval(
              //   child: Material(
              //     color: Colors.white, // button color
              //     child: InkWell(
              //       splashColor: Colors.grey, // inkwell color
              //       child: SizedBox(
              //           width: 60,
              //           height: 60,
              //           child: Icon(
              //             Icons.arrow_forward,
              //             color: Colors.black,
              //             size: 40,
              //           )),
              //       onTap: ()async {

              //       },
              //     ),
              //   ),
              // ),
            )
          ],
        ),
      );
  }
}
