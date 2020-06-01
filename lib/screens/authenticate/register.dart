import 'dart:ui';
import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/shared/constant.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:final_year_die/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/firstTime.dart';

class Register extends StatefulWidget {
  final Function tukarPandangan;
  Register({this.tukarPandangan});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _kunciForm = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    final firstTime = Provider.of<FirstTime>(context);
    return loading
        ? Loading()
        : Scaffold(
            body: Stack(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/Canal_and_Paddy_Fields.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.green[900].withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                    child: Form(
                        key: _kunciForm,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            
                            TextFormField(
                              cursorColor: Colors.yellow,
                              textCapitalization: TextCapitalization.words,
                              
                              decoration: textInputDecoration.copyWith(
                                  hintText: getTranslated(context, 'name')),
                              validator: (val) => val.length < 5
                                  ? getTranslated(context, 'name_err')
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              cursorColor: Colors.yellow,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) =>
                                  val.isEmpty ? getTranslated(context, 'email_error') : null,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              cursorColor: Colors.yellow,
                              decoration: textInputDecoration.copyWith(
                                  hintText: getTranslated(context, 'password')),
                              obscureText: true,
                              validator: (val) => val.length < 8
                                  ? getTranslated(context, 'pass_error')
                                  : null,
                              onChanged: (value) {
                                password = value;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 50,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                                onPressed: () async {
                                  if (_kunciForm.currentState.validate()) {
                                    //print(await http.read('https://flutter.dev/'));
                                    firstTime.setFirstTime(true);
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic keputusan = await _auth
                                        .signUpWithEmail(email, password,name);

                                    if (keputusan == null) {
                                      setState(() {
                                        error = getTranslated(context, 'reg_error');
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                color: Colors.white,
                                child: Text(
                                  getTranslated(context, 'reg'),
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(getTranslated(context, 'signin'),style: TextStyle(color:Colors.white),),
                                FlatButton(
                                    onPressed: () {
                                      //firstTime.setFirstTime(false);
                                      widget.tukarPandangan();
                                    },
                                    child: Text(getTranslated(context, 'signinnow'),style: TextStyle(color:Colors.yellow[600]),)),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                          ],
                        ))),
              )
            ]),
          );
  }
}
