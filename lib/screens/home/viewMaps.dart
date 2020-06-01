import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/satelliteImagery.dart';
import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/shared/last_icon_final_icons.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/user.dart';

class ViewMaps extends StatefulWidget {
  @override
  _ViewMapsState createState() => _ViewMapsState();
}

class _ViewMapsState extends State<ViewMaps> {
  int valueNow = 0;
  String imej;

  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<Satellite>(
        stream: DatabaseService(uid: pengguna.uid).satData,
        builder: (context, snapshot) {
          Satellite satellite = snapshot.data;
          if (snapshot.hasData && snapshot.data.evi != null) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(getTranslated(context, 'satellite_image'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(LastIconFinal.arrows),
                  ),
                  backgroundColor: Color(0xFF2A8D4D),
                ),
                body: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 30, 40, 5),
                        child: Row(
                          children: <Widget>[
                            Text(getTranslated(context, 'my_field'),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Color(0xFF2A8D4D),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[350],
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 7.0,
                                      spreadRadius: 2.0),
                                ]),
                            child: Container(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              hoverColor: Colors.yellow,
                                              value: 1,
                                              groupValue: valueNow,
                                              onChanged: (val) {
                                                setState(() {
                                                  valueNow = val;
                                                  imej = satellite.evi;
                                                });
                                              },
                                            ),
                                            Text('EVI',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.values[4]))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              value: 2,
                                              groupValue: valueNow,
                                              onChanged: (val) {
                                                setState(() {
                                                  valueNow = val;
                                                  imej = satellite.ndvi;
                                                });
                                              },
                                            ),
                                            Text('NDVI',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.values[4]))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              value: 3,
                                              groupValue: valueNow,
                                              onChanged: (val) {
                                                setState(() {
                                                  valueNow = val;
                                                  imej = satellite.falseColor;
                                                });
                                              },
                                            ),
                                            Text('FalseColor',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.values[4]))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                              value: 4,
                                              groupValue: valueNow,
                                              onChanged: (val) {
                                                setState(() {
                                                  valueNow = val;
                                                  imej = satellite.trueColor;
                                                });
                                              },
                                            ),
                                            Text('TrueColor',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.values[4]))
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 400,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imej == null
                                        ? AssetImage('assets/images/select.png')
                                        : NetworkImage(imej),
                                    fit: BoxFit.contain,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[350],
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 7.0,
                                        spreadRadius: 2.0),
                                  ]),
                            )),
                      )
                    ],
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }
}
