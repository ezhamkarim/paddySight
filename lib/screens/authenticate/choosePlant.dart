import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/selectMaps.dart';
import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:final_year_die/models/firstTime.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ChoosePlant extends StatefulWidget {
  @override
  _ChoosePlantState createState() => _ChoosePlantState();
}

class _ChoosePlantState extends State<ChoosePlant> {
  void showSimpleCustomDialog(BuildContext context, String text) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
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
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Okay',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  DateTime lamaDateTime = DateTime.now().toLocal();

  String paddySelected;
  final List<String> image = [
    'assets/images/paddySelect.png',
    'assets/images/paddySelect.png',
    'assets/images/paddySelect.png'
  ];

  Map<String, dynamic> jadual;

  final List<String> paddyName = ['Siraj MR297', 'MR220CL2', 'MR219'];

  @override
  Widget build(BuildContext context) {
    DateTime _dateTime =
        DateTime(lamaDateTime.year, lamaDateTime.month, lamaDateTime.day);
    final firstTime = Provider.of<FirstTime>(context);
    final pengguna = Provider.of<User>(context);

    if (firstTime.getPilihPadi) {
      return SelectMaps();
    } else {
      return MaterialApp(
        home: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Canal_and_Paddy_Fields.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.green[900].withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    getTranslated(context, 'select_paddy'),
                    style: TextStyle(
                        color: Colors.yellow[500],
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 30),
                  Container(
                      height: 450,
                      child: Swiper(
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: GestureDetector(
                              onTap: () {
                                print('Pokok ke ' + image[i].toString());
                                showDatePicker(
                                  context: context,
                                  initialDate: _dateTime == null
                                      ? DateTime.now()
                                      : _dateTime,
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime(2021),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData(
                                          primarySwatch: Colors.green,
                                          splashColor: Colors.green),
                                      child: child,
                                    );
                                  },
                                ).then((date) {
                                  setState(() {
                                    _dateTime = date;
                                    paddySelected = paddyName[i];
                                  });
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 10,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(60),
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        image[i],
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        paddyName[i],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),

                                      // Text(_dateTime == null
                                      //     ? 'Nothing has been picked yet'
                                      //     : _dateTime.toIso8601String())
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: image.length,
                        itemWidth: 200,
                        loop: false,
                        pagination: SwiperPagination(
                            margin: EdgeInsets.all(20),
                            alignment: Alignment.bottomCenter),
                        scrollDirection: Axis.horizontal,
                        controller: SwiperController(),
                        viewportFraction: 0.8,
                        scale: 0.9,
                      )),
                ],
              ),
            ),
            Positioned(
                right: 30.0,
                bottom: 30.0,
                child: ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor: Colors.grey, // inkwell color
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 40,
                          )),
                      onTap: () async {
                        if (paddySelected == null && _dateTime == null) {
                          return showSimpleCustomDialog(
                              context, getTranslated(context, 'paddy_error'));
                        } else {
                          // jadual = {
                          //   DateTime(2020,5,5).toString(): [
                          //     {
                          //       'name': 'Penanaman ',
                          //       'isDone': false,
                          //     },
                          //     {
                          //       'name': 'Kawalan Makhluk Perosak',
                          //       'isDone': false,
                          //     }
                          //   ],
                          //   DateTime(2020,5,7).toString(): [
                          //     {
                          //       'name': 'Pengurusan air',
                          //       'isDone': false,
                          //     },
                          //   ]
                          // };

                          jadual = {
                            _dateTime.toLocal().toString(): [
                              'Penanaman | Menabur benih',
                              'Kawalan Makhluk Perosak | Meninjau/mengawal tikus dan siput gondang Pomaceae',
                            ],
                            _dateTime
                                .add(Duration(days: 5))
                                .toLocal()
                                .toString(): [
                              'Pengurusan air | Memasukkan air ke dalam sawah',
                            ],
                            _dateTime
                                .add(Duration(days: 7))
                                .toLocal()
                                .toString(): [
                              'Kawalan Rumpai dan Penanaman | Mengawal pelbagai jenis rumpai dan Memeriksa penapakan pertumbuhan pokok',
                            ],
                            _dateTime
                                .add(Duration(days: 12))
                                .toLocal()
                                .toString(): [
                              'Membaja | Membaja I pada peringkat 3 helai daun',
                            ],
                            _dateTime
                                .add(Duration(days: 16))
                                .toLocal()
                                .toString(): [
                              'Kawalan Makhluk Perosak',
                            ],
                            _dateTime
                                .add(Duration(days: 45))
                                .toLocal()
                                .toString(): [
                              'Sembur Baja Foliar | Baja II',
                              'Tinjau dan Kawal Hawar Seludang, Bena Perang dan Kutu Bruang',
                              'Tinjau dan Kawal Tikus',
                            ],
                            _dateTime
                                .add(Duration(days: 50))
                                .toLocal()
                                .toString(): [
                              'Membaja | Baja III',
                              'Urus Paras Air',
                              'Kira Bil Pokok',
                            ],
                            _dateTime
                                .add(Duration(days: 55))
                                .toLocal()
                                .toString(): [
                              'Sembur Baja Foliar | Baja IV',
                            ],
                            _dateTime
                                .add(Duration(days: 65))
                                .toLocal()
                                .toString(): [
                              'Membaja | Baja V',
                            ],
                            _dateTime
                                .add(Duration(days: 70))
                                .toLocal()
                                .toString(): [
                              'Kawal Padi Angin',
                              'Tinjau Makhluk Perosak ',
                            ],
                            _dateTime
                                .add(Duration(days: 80))
                                .toLocal()
                                .toString(): [
                              'Membaja | Baja VI',
                            ],
                            _dateTime
                                .add(Duration(days: 95))
                                .toLocal()
                                .toString(): [
                              'Kawal Padi Angin',
                              'Tinjau Makhluk Perosak ',
                            ],
                            _dateTime
                                .add(Duration(days: 105))
                                .toLocal()
                                .toString(): [
                              'Menuai | Keringkan Sawah sebelum menuai',
                            ]
                          };
                          firstTime.setPilihPadi(true);
                          // print(paddySelected +
                          //     ' time' +
                          //     _dateTime.toIso8601String());

                          await DatabaseService(uid: pengguna.uid)
                              .tambahJadualPadi(jadual, _dateTime.toLocal());
                          await DatabaseService(uid: pengguna.uid)
                              .updateUserData(paddySelected);
                        }
                      },
                    ),
                  ),
                ))
          ]),
        ),
      );
    }
  }
}
