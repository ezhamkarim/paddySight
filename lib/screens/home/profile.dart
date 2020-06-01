import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/plants.dart';
import 'package:final_year_die/models/user.dart';
import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/shared/last_icon_final_icons.dart';
import 'package:final_year_die/shared/last_icon_icons.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:final_year_die/shared/plat_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/services/auth.dart';
import 'package:final_year_die/models/firstTime.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final AuthService _auth = AuthService();
  bool loading = false;
  var addresses;

  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<User>(context);
    final firstTime = Provider.of<FirstTime>(context);
    double width = MediaQuery.of(context).size.width;

    if (loading) {
      return Loading();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                firstTime.setProfileFirst(false);
              },
              child: Icon(LastIconFinal.arrows),
            ),
            backgroundColor: Color(0xFF2A8D4D),
          ),
          body: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(20),
                    child: StreamBuilder<User>(
                        stream: DatabaseService(uid: pengguna.uid).userName,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.name,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text('Loading');
                          }
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Container(
                      height: 380,
                      width: width,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Color(0xFF2A8D4D),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200],
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 7.0,
                                spreadRadius: 2.0),
                          ]),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: StreamBuilder<Plants>(
                            stream:
                                DatabaseService(uid: pengguna.uid).plantData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                double pars = double.parse(
                                    snapshot.data.area.toStringAsFixed(2));
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              //margin: EdgeInsets.all(2),
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Icon(
                                                  PlatIcon.plant,
                                                  color: Colors.yellow,
                                                  size: 35,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              snapshot.data.plantName,
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              //margin: EdgeInsets.all(2),
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Icon(
                                                  LastIcon.area,
                                                  color: Colors.yellow,
                                                  size: 35,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              pars.toString() +
                                                  getTranslated(
                                                      context, 'hectare'),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              //margin: EdgeInsets.all(2),
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Icon(
                                                  Icons.place,
                                                  color: Colors.yellow,
                                                  size: 40,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              snapshot.data.near,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                    // Text(
                                    //   pars.toString() +
                                    //       getTranslated(context, 'hectare'),
                                    //   style: TextStyle(
                                    //       fontSize: 30,
                                    //       fontWeight: FontWeight.values[4],
                                    //       color: Colors.white),
                                    // )
                                  ],
                                );
                              } else {
                                return Text('Lod');
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 150,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            loading = true;
                            firstTime.setFirstTime(false);
                            firstTime.setPilihMaps(false);
                            firstTime.setPilihPadi(false);
                            firstTime.setProfileFirst(false);
                            await _auth.signOut();
                          },
                          child: Text(
                            getTranslated(context, 'logout'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )));
    }
  }
}
