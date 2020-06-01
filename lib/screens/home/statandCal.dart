import 'package:final_year_die/localization/localization_constant.dart';

import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/shared/last_icon_final_icons.dart';
import 'package:final_year_die/shared/last_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/user.dart';
import 'package:final_year_die/models/jadualList.dart';

import 'package:final_year_die/shared/plat_icon_icons.dart';

class Kalendar extends StatefulWidget {
  @override
  KalendarState createState() => KalendarState();
}

class KalendarState extends State<Kalendar> with TickerProviderStateMixin {
  Map<DateTime, List> events;
  List selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List selectedEventCard;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  // void _handleNewDate(date) {
  //   setState(() {
  //     _selectedDay = date;
  //     _selectedEvents = events[_selectedDay] ?? [];
  //   });
  //   print(_selectedEvents);
  // }
  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      selectedEvents = events;
      _scrollController.animateTo(300,
          duration: Duration(seconds: 2), curve: Curves.ease);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  DateTime dateTime = DateTime.now().toLocal();
  ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 15),
                      decoration:
                          BoxDecoration(color: Color(0xFF2A8D4D), boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            offset: Offset(0.0, 2.0), //(x,y)
                            blurRadius: 7.0,
                            spreadRadius: 2.0),
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    DateFormat("dd MMMM yyyy").format(dateTime),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    Positioned(
                        left: 10.0,
                        top: 20.0,
                        child: Container(
                          width: 60,
                          height: 60.0,
                          child: GestureDetector(
                            child: Icon(
                              LastIconFinal.arrows,
                              size: 35,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        )),
                    buildCardHighlight()
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: <Widget>[
                      Text(
                        getTranslated(context, 'today'),
                        style: TextStyle(fontSize: 23),
                      )
                    ],
                  ),
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Switch out 2 lines below to play with TableCalendar's settings
                    //-----------------------
                    _buildTableCalendar(),
                    // _buildTableCalendarWithBuilders(),

                    const SizedBox(height: 8.0),
                    _buildEventList(),
                    const SizedBox(height: 40.0),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 40),
                //   child: buildTableCalendar(),
                // ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  // Widget buildTableCalendar() {
  //   // appBar: AppBar(
  //   //   backgroundColor: Theme.of(context).primaryColor,
  //   //   title: Text('Calendario'),
  //   // ),
  //   final pengguna = Provider.of<User>(context);
  //   return StreamBuilder<JadualList>(
  //       stream: DatabaseService(uid: pengguna.uid).jadualData,
  //       builder: (context, snapshot) {
  //         JadualList jadualList = snapshot.data;
  //           _events = {
  //   DateTime(today.year,today.month,today.day): [
  //     {'name': 'Event A', 'isDone': true},
  //   ],
  //   DateTime(2019, 3, 4): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //   ],
  //   DateTime(2019, 3, 5): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //   ],
  //   DateTime(2019, 3, 13): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //     {'name': 'Event C', 'isDone': false},
  //   ],
  //   DateTime(2019, 3, 15): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //     {'name': 'Event C', 'isDone': false},
  //   ],
  //   DateTime(2019, 3, 26): [
  //     {'name': 'Event A', 'isDone': false},
  //   ],
  //   DateTime(2020, 4, 29): [
  //     {'name': 'Berak', 'isDone': true},
  //   ],
  //   DateTime(2020, 4, 30): [
  //     {'name': 'Berak', 'isDone': true},
  //   ],
  // };
  //         if (snapshot.hasData) {
  //           benda = jadualList.events;

  //             _selectedEvents = _events[_selectedDay] ?? [];

  //           return Column(
  //             //mainAxisSize: MainAxisSize.max,
  //             children: <Widget>[
  //               Container(
  //                 height: 450,
  //                 child: Calendar(
  //                     events: _events,
  //                     onRangeSelected: (range) =>
  //                         print("Range is ${range.from}, ${range.to}"),
  //                     onDateSelected: (date) => setState(() {
  //                           _selectedDay = date;
  //                           _selectedEvents = _events[_selectedDay] ?? [];
  //                         }),

  //                     //_handleNewDate(date),
  //                     isExpandable: false,
  //                     showTodayIcon: true,
  //                     eventDoneColor: Colors.green,
  //                     eventColor: Colors.grey),
  //               ),
  //               _buildEventList(),
  //               Text(jadualList.events.toString()),
  //               SizedBox(height: 20),
  //               //Text(_events.toString()),
  //               SizedBox(height: 20),
  //             ],
  //           );
  //         } else {
  //           return CircularProgressIndicator();
  //         }
  //       });
  // }

  // Widget _buildEventList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (BuildContext context, int index) => Container(
  //       decoration: BoxDecoration(
  //         border: Border(
  //           bottom: BorderSide(width: 1.5, color: Colors.black12),
  //         ),
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
  //       child: ListTile(
  //         title: Text(_selectedEvents[index]['name'].toString()),
  //         onTap: () {
  //           print(_events.keys);
  //         },
  //       ),
  //     ),
  //     itemCount: _selectedEvents.length,
  //   );
  // }
  // Widget _buildTableUsingFirebase(){
  //    final pengguna = Provider.of<User>(context);
  //   return StreamBuilder<JadualList>(
  //       stream: DatabaseService(uid: pengguna.uid).jadualData,
  //       builder: (context, snapshot) {
  //         JadualList jadualList = snapshot.data;
  //         if (snapshot.hasData) {
  //           //final _selectedDay = jadualList.startDate;
  //          // _selectedEvents = _events[_selectedDay] ?? [];
  //           List<Map<String, dynamic>> listEvents = jadualList.listEvents;
  //           List<dynamic> listforEachDay = [];

  //             flag = true;

  //           return Padding(
  //             padding: const EdgeInsets.fromLTRB(40, 20, 40, 15),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(6.0),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(6.0),
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: Colors.grey[300],
  //                           offset: Offset(0.0, 1.0), //(x,y)
  //                           blurRadius: 7.0,
  //                           spreadRadius: 2.0),
  //                     ]),
  //                 child: TableCalendar(
  //                     events: _events,
  //                     headerStyle: HeaderStyle(
  //                       centerHeaderTitle: true,
  //                     ),
  //                     calendarStyle: CalendarStyle(
  //                         todayColor: Color(0xFF2A8D4D),
  //                         selectedColor: Color(0xFFEABB17)),
  //                     onDaySelected: _onDaySelected,
  //                     onVisibleDaysChanged: _onVisibleDaysChanged,
  //                     onCalendarCreated: _onCalendarCreated,
  //                     calendarController: _calendarController),
  //               ),
  //             ),
  //           );
  //         } else {
  //           return CircularProgressIndicator();
  //         }
  //       });
  // }

  Widget _buildTableCalendar() {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<JadualList>(
        stream: DatabaseService(uid: pengguna.uid).jadualData,
        builder: (context, snapshot) {
          JadualList jadualList = snapshot.data;
          if (snapshot.hasData) {
            final _selectedDay = jadualList.startTime;
            events = jadualList.events;
            // _events = {
            //   _selectedDay: ['Penanaman', 'Kawalan Makhluk Perosak'],
            //   _selectedDay.add(Duration(days: 5)): ['Pengurusan air'],
            //   _selectedDay.add(Duration(days: 7)): [
            //     'Kawalan Rumpai dan Penanaman'
            //   ],
            //   _selectedDay.add(Duration(days: 12)): ['Membaja 1'],
            //   _selectedDay.add(Duration(days: 16)): ['Kawalan Makhluk Perosak 2'],
            //   _selectedDay.add(Duration(days: 45)): [
            //     'Sembur Baja Foliar',
            //     'Tinjau dan Kawal Hawar Seludang, Bena Perang dan Kutu Bruang',
            //     'Tinjau dan Kawal Tikus'
            //   ],
            //   _selectedDay.add(Duration(days: 50)): [
            //     'Membaja 2',
            //     'Urus Paras Air',
            //     'Kira Bil Pokok'
            //   ],
            //   _selectedDay.add(Duration(days: 55)): ['Sembur Baja Foliar 2'],
            //   _selectedDay.add(Duration(days: 65)): ['Membaja 3'],
            //   _selectedDay.add(Duration(days: 70)): [
            //     'Kawal Padi Angin 1',
            //     'Tinjau Makhluk Perosak 1'
            //   ],
            //   _selectedDay.add(Duration(days: 80)): ['Membaja 4'],
            //   _selectedDay.add(Duration(days: 95)): [
            //     'Kawal Padi Angin 2',
            //     'Tinjau Makhluk Perosak 2'
            //   ],
            //   _selectedDay.add(Duration(days: 105)): ['Menuai']
            // };

            selectedEvents = events[_selectedDay] ?? [];

            // firstTime.setPilihCalendaer(true);

            return Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 7.0,
                            spreadRadius: 2.0),
                      ]),
                  child: TableCalendar(
                      events: events,
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                      ),
                      calendarStyle: CalendarStyle(
                          todayColor: Color(0xFF2A8D4D),
                          selectedColor: Color(0xFFEABB17)),
                      onDaySelected: _onDaySelected,
                      onVisibleDaysChanged: _onVisibleDaysChanged,
                      onCalendarCreated: _onCalendarCreated,
                      calendarController: _calendarController),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildEventList() {
    //Plants plants = snapshot.data;
    if (selectedEvents?.isNotEmpty ?? false) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: selectedEvents
              .map((event) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Color(0xFFEABB17)),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        event.toString(),
                        style: TextStyle(fontWeight: FontWeight.values[4]),
                      ),
                      leading: GestureDetector(
                          child: Icon(
                        Icons.notifications,
                        color: Colors.green,
                      )),
                      onTap: () => print('$event tapped! '),
                    ),
                  ))
              .toList(),
        ),
      );
    } else {
      return Text(getTranslated(context, 'no_event'));
    }
  }

  Widget buildCardHighlight() {
    final _dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final pengguna = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 120, 40.0, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 380,
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
          child: Container(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                child: Text(
                  getTranslated(context, 'highlight'),
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.values[4]),
                ),
              ),
              StreamBuilder<JadualList>(
                  stream: DatabaseService(uid: pengguna.uid).jadualData,
                  builder: (context, snapshot) {
                    JadualList jadualList = snapshot.data;
                    if (snapshot.hasData) {
                      events = jadualList.events;
                      selectedEventCard = events[_dateTime] ?? [];
                      return Container(
                        height: 220,
                        //padding: const EdgeInsets.symmetric(vertical: 5),
                        child: events.containsKey(_dateTime)
                            ? ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: selectedEventCard
                                    .map((event) => Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Color(0xFFEABB17)),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2.0),
                                          child: ListTile(
                                            title: Container(
                                                child: Text(event.toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .values[4]))),
                                            leading: Icon(
                                              Icons.notifications_active,
                                              color: Color(0xFF2A8D4D),
                                              size: 35,
                                            ),
                                            onTap: () =>
                                                print('$event tapped! '),
                                          ),
                                        ))
                                    .toList(),
                              )
                            : Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Center(
                                    child: Text(
                                        getTranslated(context, 'no_event')))),
                      );
                    } else {
                      return Text(getTranslated(context, 'load'));
                    }
                  }),
              Divider(),
              StreamBuilder<JadualList>(
                  stream: DatabaseService(uid: pengguna.uid).jadualData,
                  builder: (context, snapshot) {
                    JadualList jadualList = snapshot.data;
                    if (snapshot.hasData &&
                        _dateTime.difference(jadualList.startTime).inDays <=
                            16) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Icon(PlatIcon.plant),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                  getTranslated(context, 'phase') +
                                      getTranslated(context, 'germ'),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData &&
                        _dateTime.difference(jadualList.startTime).inDays <=
                            50) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Icon(LastIcon.vege),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                  getTranslated(context, 'phase') +
                                      getTranslated(context, 'vege'),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData &&
                        _dateTime.difference(jadualList.startTime).inDays <=
                            70) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Icon(LastIcon.repro),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                  getTranslated(context, 'phase') +
                                      getTranslated(context, 'repro'),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData &&
                        _dateTime.difference(jadualList.startTime).inDays <=
                            105) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Icon(LastIcon.ripen),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                  getTranslated(context, 'phase') +
                                      getTranslated(context, 'rip'),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData &&
                        _dateTime.difference(jadualList.startTime).inDays >
                            105) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Icon(LastIcon.mature),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                  getTranslated(context, 'phase') +
                                      getTranslated(context, 'mat'),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                          child: Text(getTranslated(context, 'load')));
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
//   child: ClipRRect(
//     borderRadius: BorderRadius.circular(6.0),
//     child: Container(
//       height: 80,
//       margin: EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//           color: Color(0xFF2A8D4D),
//           borderRadius: BorderRadius.circular(6.0),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey[300],
//                 offset: Offset(0.0, 1.0), //(x,y)
//                 blurRadius: 7.0,
//                 spreadRadius: 2.0),
//           ]),
//       child: Container(
//         padding: EdgeInsets.all(15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   'In Progress',
//                   style: TextStyle(
//                       fontSize: 25, color: Colors.white),
//                 ),
//                 Text(
//                   'Pesticiding Day',
//                   style: TextStyle(
//                       fontSize: 15, color: Colors.white),
//                 )
//               ],
//             ),
//             VerticalDivider(
//               thickness: 2,
//               color: Colors.white,
//             ),
//             Icon(Icons.check, color: Colors.white),
//             Icon(Icons.delete_forever, color: Colors.white)
//           ],
//         ),
//       ),
//     ),
//   ),
// ),
