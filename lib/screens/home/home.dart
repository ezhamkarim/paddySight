import 'dart:convert';
import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/plants.dart';
import 'package:final_year_die/models/polygon.dart';
import 'package:final_year_die/screens/home/account.dart';
import 'package:final_year_die/screens/home/inventory.dart';
import 'package:final_year_die/screens/home/profile.dart';
import 'package:final_year_die/screens/home/statandCal.dart';
import 'package:final_year_die/screens/home/viewMaps.dart';
import 'package:final_year_die/models/user.dart';
import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/shared/last_icon_icons.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:final_year_die/shared/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/firstTime.dart';
import 'package:http/http.dart' as http;
import 'package:final_year_die/models/satelliteImagery.dart';
import 'package:final_year_die/models/weatherData.dart';
import 'package:final_year_die/shared/plat_icon_icons.dart';
import 'package:translator/translator.dart';

final String apiKey = '53d3f07fa4557b15df2ecda8aff79a42';

Future<Satellite> searchImage(String polygonID, String startDate,
    String endDate, String resolution) async {
  print(polygonID + 'startdate :' + startDate + 'end date :' + endDate);

  final http.Response response = await http.get(
    "http://api.agromonitoring.com/agro/1.0/image/search?start=$startDate&end=$endDate&polyid=$polygonID&appid=$apiKey&resolution_min=$resolution&",
    // body: jsonEncode(
    //   <String, dynamic> {"polygon_id": polygonID, "start":startDate, "end" : endDate}
    // )
  );

  if (response.statusCode == 200) {
    print("SAYA BEWRJAYA");

    return Satellite.fromJson(json.decode(response.body));
  } else {
    print('GAGAL');
    return null;
  }
}

Future<SoilData> getSoil(
    String polyID, String startDate, String endDate) async {
  final http.Response response = await http.get(
      'http://api.agromonitoring.com/agro/1.0/soil?polyid=$polyID&appid=$apiKey');

  if (response.statusCode == 200) {
    return SoilData.fromJson(jsonDecode(response.body));
  } else {
    return Future.error('Error');
  }
}

class Home extends StatefulWidget {
  final String polyID;

  // final LatLng point;
  Home({this.polyID});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int startDate =
      DateTime.now().subtract(Duration(days: 365 * 3)).millisecondsSinceEpoch ~/
          1000;
  final int endDate =
      DateTime.now().subtract(Duration(days: 265 * 3)).millisecondsSinceEpoch ~/
          1000;
  final String resolution = '1080x1920';

  String _polyID;

  PolygonData polygonData = PolygonData();
  String trueColor;
  String falseColor;
  String ndvi;
  String evi;
  Future<SoilData> soilData;

  @override
  void initState() {
    //print('hi'+widget.polyID);
    _polyID = widget.polyID;

    super.initState();

    // _futureSearchImage = searchImage(polyID, startDate.toString(), endDate.toString());
  }

  @override
  Widget build(BuildContext context) {
    //final polyData = Provider.of<PolygonData>(context);
    final pengguna = Provider.of<User>(context);
    final firstTime = Provider.of<FirstTime>(context);
    print(startDate.toString());
    print(endDate.toString());
    //print('HAII NI START DATE '+startDate);

    //turnToCoors();
    if (firstTime.getProfilePage) {
      return MyProfile();
    } else {
      return StreamBuilder<Plants>(
          stream: DatabaseService(uid: pengguna.uid).plantData,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.polygonID != null) {
              Plants plants = snapshot.data;

              return Scaffold(
                body: Container(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 200,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xFF2A8D4D),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300],
                                        offset: Offset(0.0, 2.0), //(x,y)
                                        blurRadius: 7.0,
                                        spreadRadius: 2.0),
                                  ]),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          StreamBuilder<User>(
                                              stream: DatabaseService(
                                                      uid: pengguna.uid)
                                                  .userName,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    'Hi ' + snapshot.data.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                } else {
                                                  return Text('Loading..');
                                                }
                                              }),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                            color: Colors.blue,
                                            onPressed: () {
                                              firstTime.setProfileFirst(true);
                                            },
                                            child: Text(
                                              getTranslated(context, 'profile'),
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                            Builder(builder: (context) {
                              if (_polyID != null) {
                                return Weather(
                                  polyID: _polyID,
                                );
                              } else {
                                return Weather(
                                  polyID: plants.polygonID,
                                );
                              }
                            })
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Text(getTranslated(context, 'what_todo'))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              height: 150,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xFF2A8D4D),
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300],
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 7.0,
                                        spreadRadius: 2.0),
                                  ]),
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Container(
                                  //color: Colors.black,
                                  child: FutureBuilder(
                                    future: soilData = getSoil(
                                        plants.polygonID,
                                        startDate.toString(),
                                        endDate.toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        double potong = double.parse(snapshot
                                            .data.soil
                                            .toStringAsFixed(2));

                                        double pokokPerHectare =
                                            plants.area * 10000 * 370;
                                        double k22 = (300 * 120 * 25) / 100000;
                                        double k22Parsed = double.parse(
                                            k22.toStringAsFixed(2));
                                        double kdynamic = ((100.00 - 22.00) /
                                                (100.00 - potong)) *
                                            k22Parsed;
                                        double kdynParsed = double.parse(
                                            kdynamic.toStringAsFixed(2));
                                        double hasil = kdynParsed * 1250;
                                        double hasilParsed = double.parse(
                                            hasil.toStringAsFixed(2));
                                        return Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                // Text(

                                                //       plants.area.toString() +
                                                //       getTranslated(context, 'hectare'),
                                                //   style: TextStyle(
                                                //       fontSize: 16,
                                                //       color: Colors.white,
                                                //       fontWeight:
                                                //           FontWeight.values[2]),
                                                // ),
                                                // SizedBox(
                                                //   height: 5,
                                                // ),
                                                // Text(
                                                //   '' +
                                                //       pokokPerHectare
                                                //           .toInt()
                                                //           .toString() +
                                                //       getTranslated(context, 'paddy'),
                                                //   style: TextStyle(
                                                //       fontSize: 16,
                                                //       color: Colors.white,
                                                //       fontWeight:
                                                //           FontWeight.values[2]),
                                                // ),
                                                // SizedBox(
                                                //   height: 5,
                                                // ),
                                                Text(
                                                  '' +
                                                      kdynParsed.toString() +
                                                      getTranslated(
                                                          context, 'tonper'),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  getTranslated(
                                                          context, 'moist') +
                                                      potong.toString() +
                                                      ' %',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.values[2]),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  getTranslated(
                                                          context, 'amount') +
                                                      ' RM ' +
                                                      hasilParsed.toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.values[2]),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),

                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: <Widget>[
                                            //     Text(
                                            //       'RM 1250/TM',
                                            //       style: TextStyle(
                                            //         fontSize: 16,
                                            //         color: Colors.white,
                                            //         fontWeight:
                                            //               FontWeight.bold
                                            //       ),
                                            //     ),
                                            //     SizedBox(
                                            //       height: 10,
                                            //     ),
                                            //     Text(
                                            //       getTranslated(context, 'amount'),
                                            //       style: TextStyle(
                                            //           fontSize: 18,
                                            //           color: Colors.white,
                                            //           fontWeight:
                                            //               FontWeight.values[2]),
                                            //     ),
                                            //     SizedBox(
                                            //       height: 5,
                                            //     ),
                                            //
                                            //   ],
                                            // )
                                          ],
                                        );
                                      } else {
                                        return Center(
                                            child: Text(getTranslated(
                                                context, 'load')));
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                children: <Widget>[
                                  Text(getTranslated(context, 'main_thing')),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Container(
                                height: 96,
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Kalendar()),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey[200],
                                                    offset: Offset(
                                                        0.0, 1.0), //(x,y)
                                                    blurRadius: 7.0,
                                                    spreadRadius: 2.0),
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.calendar_today),
                                              Text(
                                                getTranslated(
                                                    context, 'calendar'),
                                                style: TextStyle(
                                                    color: Color(0xFF2A8D4D)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Account()),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey[200],
                                                    offset: Offset(
                                                        0.0, 1.0), //(x,y)
                                                    blurRadius: 7.0,
                                                    spreadRadius: 2.0),
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(LastIcon.account),
                                              Text(
                                                getTranslated(
                                                    context, 'account'),
                                                style: TextStyle(
                                                    color: Color(0xFF2A8D4D)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Inventory()),
                                          );
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(5),
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[200],
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 7.0,
                                                      spreadRadius: 2.0),
                                                ]),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(LastIcon.inventory),
                                                Text(
                                                  getTranslated(
                                                      context, 'inventory'),
                                                  style: TextStyle(
                                                      color: Color(0xFF2A8D4D)),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          searchImage(
                                                  plants.polygonID,
                                                  startDate.toString(),
                                                  endDate.toString(),
                                                  resolution)
                                              .then((Satellite satellite) {
                                            setState(() {
                                              falseColor = satellite.falseColor;
                                              trueColor = satellite.trueColor;
                                              ndvi = satellite.ndvi;
                                              evi = satellite.evi;

                                              DatabaseService(uid: pengguna.uid)
                                                  .tambahImage(ndvi, evi,
                                                      falseColor, trueColor);
                                            });
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewMaps()),
                                          );
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(5),
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[200],
                                                      offset: Offset(
                                                          0.0, 1.0), //(x,y)
                                                      blurRadius: 7.0,
                                                      spreadRadius: 2.0),
                                                ]),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(PlatIcon.satellite),
                                                Text(
                                                  getTranslated(
                                                      context, 'satellite'),
                                                  style: TextStyle(
                                                      color: Color(0xFF2A8D4D)),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //SizedBox(height: 300),
                            // Text(firstTime.getFirstTime.toString()),
                            // Text(pengguna.uid),
                            // Container(
                            //     child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: <Widget>[Text('Hello')],
                            // )),

                            // Text('Masa start ' + plants.dateTimeStart),
                            // Text('Tanaman :' + plants.plantName),
                          ],
                        ),
                      ]))
                    ],
                  ),
                ),
              );
            } else {
              return Loading();
            }
          });
    }
  }

  void tunjukDialog(BuildContext context) {
    AlertDialog(
      title: Text('Cannot Register Field'),
      content: Text('Field is out of boundry'),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

Future<WeatherData> getWeather(String polyID) async {
  final http.Response response = await http.get(
      'http://api.agromonitoring.com/agro/1.0/weather?polyid=$polyID&appid=$apiKey');

  if (response.statusCode == 200) {
    return WeatherData.fromJson(jsonDecode(response.body));
  } else {
    return Future.error('Error');
  }
}

class Weather extends StatefulWidget {
  final String polyID;

  Weather({this.polyID});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _polyID;
  Future<WeatherData> futureWeatherData;
  final translator = GoogleTranslator();
  String translation;
  @override
  void initState() {
    super.initState();
    _polyID = widget.polyID;
    futureWeatherData = getWeather(_polyID);
  }

  // void translate(String description) async{
  //   translation = await translator.translate(description, to: 'ms');
  //   setState(() {
  //     translation =
  //   });

  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 120, 40.0, 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // FutureBuilder<WeatherData>(
                //     future: futureWeatherData,
                //     builder: (context, snapshots) {
                //       if (snapshots.hasData) {

                //         if(firstTime.getBahasa=='en'){
                //           return Text(
                //             'It is ' + snapshots.data.description + ' day',
                //             style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.values[2],
                //                 color: Colors.white),
                //           );
                //         }
                //           else{
                //             return Text(
                //             'It is ' + snapshots.data.description + ' day',
                //             style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.values[2],
                //                 color: Colors.white),
                //           );
                //           }

                //       } else {
                //         return CircularProgressIndicator();
                //       }
                //     }),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Container(
              height: 200,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[200],
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 7.0,
                        spreadRadius: 2.0),
                  ]),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                        width: 135,
                        margin: EdgeInsets.only(right: 10),
                        child: Row(children: <Widget>[
                          Container(
                            //margin: EdgeInsets.all(2),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF2DCD87),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                (MyFlutterApp.temperatire),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<WeatherData>(
                                  future: futureWeatherData,
                                  builder: (context, snapshots) {
                                    if (snapshots.hasData) {
                                      return Text(
                                        snapshots.data.temp
                                                .truncate()
                                                .toString() +
                                            '\u{00B0} c',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return Center(
                                          child: Text(
                                              getTranslated(context, 'load')));
                                    }
                                  },
                                ),
                                Text(
                                  getTranslated(context, 'temp'),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ])
                        ]),
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          Container(
                            //margin: EdgeInsets.all(2),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF2CA6CB),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                LastIcon.wind,
                                color: Colors.white,
                                size: 45,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<WeatherData>(
                                  future: futureWeatherData,
                                  builder: (context, snapshots) {
                                    if (snapshots.hasData) {
                                      return Text(
                                          snapshots.data.wind.toString() +
                                              'm/s',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold));
                                    } else {
                                      return Center(
                                          child: Text(
                                              getTranslated(context, 'load')));
                                    }
                                  },
                                ),
                                Text(
                                  getTranslated(context, 'wind'),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ])
                        ]),
                      ),
                    ]),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 135,
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                //margin: EdgeInsets.all(2),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xFF9A70D2),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    MyFlutterApp.humidity,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FutureBuilder<WeatherData>(
                                      future: futureWeatherData,
                                      builder: (context, snapshots) {
                                        if (snapshots.hasData) {
                                          return Text(
                                              snapshots.data.humidity
                                                      .toString() +
                                                  '%',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold));
                                        } else {
                                          return Center(
                                              child: Text(getTranslated(
                                                  context, 'load')));
                                        }
                                      },
                                    ),
                                    Text(
                                      getTranslated(context, 'humidity'),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ]),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                //margin: EdgeInsets.all(2),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xFFEABB17),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    MyFlutterApp.cloud_wind,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FutureBuilder<WeatherData>(
                                      future: futureWeatherData,
                                      builder: (context, snapshots) {
                                        if (snapshots.hasData) {
                                          return Text(
                                              snapshots.data.cloud.toString() +
                                                  '%',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold));
                                        } else {
                                          return Center(
                                              child: Text(getTranslated(
                                                  context, 'load')));
                                        }
                                      },
                                    ),
                                    Text(
                                      getTranslated(context, 'cloud'),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ]),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tunjukDialog(BuildContext context) {
    AlertDialog(
      title: Text('Cannot Register Field'),
      content: Text('Field is out of boundry'),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
