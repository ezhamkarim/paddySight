import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/accountList.dart';
import 'package:final_year_die/services/database.dart';
import 'package:final_year_die/shared/last_icon_final_icons.dart';
import 'package:final_year_die/shared/last_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:final_year_die/shared/plat_icon_icons.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/user.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int _selectedId = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: CustomScrollView(slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          Stack(
            children: <Widget>[
              Container(
                height: 200,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Color(0xFF2A8D4D), boxShadow: [
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
                              getTranslated(context, 'account'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
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
                        color: Colors.white,
                        size: 35,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )),
              AccountCard()
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        child: MyDialog(
                          onValueChange: _onValueChange,
                          initialValue: _selectedId,
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Color(0xFF2A8D4D),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 2.0), //(x,y)
                              blurRadius: 7.0,
                              spreadRadius: 2.0),
                        ]),
                    child: Center(
                      child: Icon(
                        (LastIconFinal.add),
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[_buildList()])
        ]))
      ])),
    );
  }

  Widget _buildList() {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<AccountList>(
        stream: DatabaseService(uid: pengguna.uid).accountData,
        builder: (context, snapshot) {
          AccountList list = snapshot.data;
          if (snapshot.hasData) {
            return Container(
              alignment: Alignment.topCenter,
              height: 350,
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: list.accountList.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),

                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  
                                    Center(child: Container(height: 200, 
                                    
                                    decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[300],
                                              offset: Offset(0.0, 2.0), //(x,y)
                                              blurRadius: 14,
                                              spreadRadius: 2.0) ]),
                                    child: VerticalDivider(thickness:5,color: Colors.grey[100]))),
                                    
                                  
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: list.accountList[i]["TypeOf"] ==
                                                'Revenue'
                                            ? Colors.white54
                                            : Color(0xFF2A8D4D),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[300],
                                              offset: Offset(0.0, 2.0), //(x,y)
                                              blurRadius: 7.0,
                                              spreadRadius: 2.0),
                                        ]),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 150,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: list.accountList[i]["TypeOf"] ==
                                            'Revenue'
                                        ? Color(0xFF2A8D4D)
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[350],
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 7.0,
                                          spreadRadius: 2.0),
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              // Text(list.accountList[i]['TypeOf']),
                                              Builder(builder: (context) {
                                                if (list.accountList[i]
                                                        ['TypeOf'] ==
                                                    'Revenue') {
                                                  return Text(
                                                      getTranslated(
                                                          context, 'revenue'),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                } else {
                                                  return Text(
                                                      getTranslated(
                                                          context, 'expense'),
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                }
                                              }),
                                              Text(
                                                  'RM ' +
                                                      list.accountList[i]
                                                              ['Amount']
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: list.accountList[i]
                                                                  ["TypeOf"] ==
                                                              'Revenue'
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              list.accountList[i]
                                                  ['Description'],
                                              style: TextStyle(
                                                  color: list.accountList[i]
                                                              ["TypeOf"] ==
                                                          'Revenue'
                                                      ? Colors.yellow
                                                      : Color(0xFF2A8D4D),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // child: ListTile(
                      //   leading: Text(list.accountList[i]['Amount']),
                      //   title: Text(list.accountList[i]['Description']),
                      //   trailing: Text(list.accountList[i]['TypeOf']),
                      // ),
                    );
                  }),
            );
          } else {
            return Text('Loading..');
          }
        });
  }

  void _onValueChange(int value) {
    setState(() {
      _selectedId = value;
    });
  }
}

class AccountCard extends StatefulWidget {
  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<AccountList>(
        stream: DatabaseService(uid: pengguna.uid).accountData,
        builder: (context, snapshot) {
          AccountList list = snapshot.data;
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(40, 120, 40, 10),
              child: Column(children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 250,
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right:10),
                              child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Color(0xFF44A2BE),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    (PlatIcon.money), size: 50,
                                    color: Colors.white,
                                    //color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(getTranslated(context, 'revenue'),
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    Text('RM ' + list.totalRevenue.toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold))
                                  ])
                            ],
                          )),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                              // margin: EdgeInsets.only(right:10),
                              child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Color(0xFF9A70D2),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    (LastIcon.expense),
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      getTranslated(context, 'expense'),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'RM ' + list.totalExpense.toString(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(40, 120, 40, 10),
              child: Column(children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 250,
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right:10),
                              child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Color(0xFF44A2BE),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    (PlatIcon.money),
                                    //color: Colors.white,
                                  ),
                                ),
                              ),
                              Column(children: <Widget>[
                                Text("Revenue"),
                                Text('Rm 0')
                              ])
                            ],
                          )),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                              // margin: EdgeInsets.only(right:10),
                              child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Color(0xFF9A70D2),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    (PlatIcon.expenses),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Column(children: <Widget>[
                                Text("Expense"),
                                Text('Rm 0')
                              ])
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            );
          }
        });
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue});

  final int initialValue;
  final void Function(int) onValueChange;
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController _textAmountController = TextEditingController();
  TextEditingController _textDescriptionController = TextEditingController();
  final _kunciForm = GlobalKey<FormState>();
  int _selectedId;
  String typeof = 'Revenue';
  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<User>(context);
    return AlertDialog(
      title: Text(getTranslated(context, 'dialog_acc')),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 240,
        child: Form(
          key: _kunciForm,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                          value: 1,
                          groupValue: _selectedId,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedId = value;
                              typeof = 'Revenue';
                            });
                            // widget.onValueChange(value);
                          }),
                      SizedBox(width: 10),
                      Text(getTranslated(context, 'revenue')),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                          value: 2,
                          groupValue: _selectedId,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedId = value;
                              typeof = 'Expense';
                            });
                            // widget.onValueChange(value);
                          }),
                      SizedBox(width: 10),
                      Text(getTranslated(context, 'expense')),
                    ],
                  )
                ],
              ),
              TextFormField(
                controller: _textAmountController,
                keyboardType: TextInputType.number,
                validator: (val) => val.isEmpty
                    ? getTranslated(context, 'error_acc_dialog')
                    : null,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                decoration: InputDecoration(
                    hintText: getTranslated(context, 'hint_amount')),
              ),
              TextFormField(
                controller: _textDescriptionController,
                validator: (val) => val.isEmpty
                    ? getTranslated(context, 'error_acc_dialog2')
                    : null,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                decoration: InputDecoration(
                    hintText: getTranslated(context, 'hint_desc')),
                maxLines: 3,
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
              if (typeof == 'Expense') {
                double amount = double.parse(_textAmountController.text);
                Map<String, dynamic> addAccount = {
                  "TypeOf": typeof,
                  "Amount": amount,
                  "Description": _textDescriptionController.text
                };

                DatabaseService(uid: pengguna.uid).tambahAccount(addAccount,
                    totalExpense: amount, totalRevenue: 0);
              } else {
                double amount = double.parse(_textAmountController.text);
                Map<String, dynamic> addAccount = {
                  "TypeOf": typeof,
                  "Amount": amount,
                  "Description": _textDescriptionController.text
                };

                DatabaseService(uid: pengguna.uid).tambahAccount(addAccount,
                    totalRevenue: amount, totalExpense: 0);
              }

              Navigator.of(context).pop();
              //print(_textAmountController.text +' '+_textDescriptionController.text+ 'typeof '+typeof);

            }
          },
        )
      ],
    );
  }
}
