import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/inventoryList.dart';
import 'package:final_year_die/shared/last_icon_final_icons.dart';
import 'package:final_year_die/shared/plat_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:final_year_die/services/database.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/user.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void scrollToMachineryCard() {
    _scrollController.animateTo(100,
        duration: Duration(seconds: 2), curve: Curves.ease);
  }

  void scrollToToolsCard() {
    _scrollController.animateTo(400,
        duration: Duration(seconds: 2), curve: Curves.ease);
  }

  void scrollToCropCard() {
    _scrollController.animateTo(800,
        duration: Duration(seconds: 2), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, 'inventory'),
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            LastIconFinal.arrows
          ),
        ),
        backgroundColor: Color(0xFF2A8D4D),
      ),
      body: Container(
        child:
            CustomScrollView(controller: _scrollController, slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 60,
                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'barn'),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 130,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: GestureDetector(
                            onTap: scrollToMachineryCard,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 7.0,
                                        spreadRadius: 2.0),
                                  ]),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      PlatIcon.tractor,
                                      size: 50,
                                    ),
                                    Text(getTranslated(context, 'machinery'),style: TextStyle(
              fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: GestureDetector(
                            onTap: scrollToToolsCard,
                            child: Container(
                                margin: EdgeInsets.all(10),
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 7.0,
                                          spreadRadius: 2.0),
                                    ]),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Icon(
                                        PlatIcon.shovel,
                                        size: 50,
                                      ),
                                      Text(getTranslated(context, 'tools'),style: TextStyle(
              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: GestureDetector(
                            onTap: scrollToCropCard,
                            child: Container(
                                margin: EdgeInsets.all(10),
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 7.0,
                                          spreadRadius: 2.0),
                                    ]),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Icon(
                                        PlatIcon.plant,
                                        size: 50,
                                      ),
                                      Text(getTranslated(context, 'crop'),style: TextStyle(
              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                offset: Offset(0.0, -1.0), //(x,y)
                                blurRadius: 7.0,
                                spreadRadius: 2.0),
                          ]),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getTranslated(context, 'machinery'),
                              style:
                                  TextStyle(color: Color(0xFF2A8D4D), fontSize: 30,fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      child: buildDialog(
                                        context, getTranslated(context, 'machinery'),
                                      ));
                                },
                                child: Icon(
                                  LastIconFinal.add,
                                  color: Color(0xFF2A8D4D),
                                  size: 30,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
                      height: 300,
                      decoration: BoxDecoration(
                          color: Color(0xFF2A8D4D),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                offset: Offset(0.0, 3.0), //(x,y)
                                blurRadius: 7.0,
                                spreadRadius: 2.0),
                          ]),
                      child: _buildMachineryList(),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                offset: Offset(0.0, -1.0), //(x,y)
                                blurRadius: 7.0,
                                spreadRadius: 2.0),
                          ]),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getTranslated(context, 'tools'),
                              style:
                                  TextStyle(color: Color(0xFF2A8D4D), fontSize: 30,fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      child: buildDialog(
                                        context,getTranslated(context, 'tools'),
                                      ));
                                },
                                child: Icon(
                                  LastIconFinal.add,
                                  color: Color(0xFF2A8D4D),
                                  size: 30,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
                        height: 300,
                        decoration: BoxDecoration(
                            color: Color(0xFF2A8D4D),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400],
                                  offset: Offset(0.0, 3.0), //(x,y)
                                  blurRadius: 7.0,
                                  spreadRadius: 2.0),
                            ]),
                        child: _buildToolsList())
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                offset: Offset(0.0, -1.0), //(x,y)
                                blurRadius: 7.0,
                                spreadRadius: 2.0),
                          ]),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getTranslated(context, 'crop'),
                              style:
                                  TextStyle(color: Color(0xFF2A8D4D), fontSize: 30,fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      child: buildDialog(
                                        context, getTranslated(context, 'crop'),
                                      ));
                                },
                                child: Icon(
                                  LastIconFinal.add,
                                  color: Color(0xFF2A8D4D),
                                  size: 30,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
                        height: 300,
                        decoration: BoxDecoration(
                            color: Color(0xFF2A8D4D),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400],
                                  offset: Offset(0.0, 3.0), //(x,y)
                                  blurRadius: 7.0,
                                  spreadRadius: 2.0),
                            ]),
                        child: _buildCropList())
                  ],
                ),
              ),
              SizedBox(height: 100)
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildMachineryList() {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<InventoryList>(
      stream: DatabaseService(uid: pengguna.uid).inventoryData,
      builder: (context, snapshot) {
        InventoryList inventoryList = snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: inventoryList.machinery.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text('- '+inventoryList.machinery[i]['item'],style:
                                  TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      Text('('+inventoryList.machinery[i]['amount'].toString()+')',style:
                                  TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),)
                    ],
                  ),
                );
              });
        } else {
          return Text('Add Your Inventory');
        }
      },
    );
  }

  Widget _buildCropList() {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<InventoryList>(
      stream: DatabaseService(uid: pengguna.uid).inventoryData,
      builder: (context, snapshot) {
        InventoryList inventoryList = snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: inventoryList.crop.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text('- '+inventoryList.crop[i]['item'],style:
                                  TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      Text('('+inventoryList.crop[i]['amount'].toString()+')',style:
                                  TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),)
                    ],
                  ),
                );
              });
        } else {
          return Text('Add Your Inventory');
        }
      },
    );
  }

  Widget _buildToolsList() {
    final pengguna = Provider.of<User>(context);
    return StreamBuilder<InventoryList>(
      stream: DatabaseService(uid: pengguna.uid).inventoryData,
      builder: (context, snapshot) {
        InventoryList inventoryList = snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: inventoryList.tools.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text('- '+inventoryList.tools[i]['item'],style:
                                  TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      Text('('+inventoryList.tools[i]['amount'].toString()+')',style:
                                  TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),)
                    ],
                  ),
                );
              });
        } else {
          return Text('Add Your Inventory');
        }
      },
    );
  }




  TextEditingController _textAmountController = TextEditingController();
  TextEditingController _textItemController = TextEditingController();
  final _kunciForm = GlobalKey<FormState>();


  
  Widget buildDialog(BuildContext context, String _inventoryType) {
    final pengguna = Provider.of<User>(context,listen: false);
    return AlertDialog(
      title: Text(getTranslated(context, 'enter') + _inventoryType + getTranslated(context, 'in_your')),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 240,
        child: Form(
          key: _kunciForm,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _textItemController,
                validator: (val) => val.isEmpty ? getTranslated(context, 'err_inv_dialog') : null,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: getTranslated(context, 'item')),
                maxLines: 3,
              ),
              TextFormField(
                controller: _textAmountController,
                keyboardType: TextInputType.number,
                validator: (val) => val.isEmpty ? getTranslated(context, 'error_acc_dialog') : null,
                inputFormatters: [LengthLimitingTextInputFormatter(3)],
                decoration: InputDecoration(hintText: getTranslated(context, 'hint_amount')),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Okay'),
          onPressed: () {
            if (_kunciForm.currentState.validate()) {
              int amount = int.parse(_textAmountController.text);
              Map<String, dynamic> itemData = {
                'item': _textItemController.text,
                'amount': amount
              };
              if (_inventoryType == 'Machinery'||_inventoryType == 'Mesin') {
                scrollToMachineryCard();
                DatabaseService(uid: pengguna.uid)
                    .tambahInventory(addMachinery: itemData);
              } else if (_inventoryType == 'Tools'||_inventoryType == 'Peralatan') {
                scrollToToolsCard();
                DatabaseService(uid: pengguna.uid)
                    .tambahInventory(addTools: itemData);
              } else {
                scrollToCropCard();
                DatabaseService(uid: pengguna.uid)
                    .tambahInventory(addCrop: itemData);
              }
              _textItemController.clear();
              _textAmountController.clear();
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
