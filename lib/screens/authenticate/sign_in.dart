import 'dart:ui';
import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/main.dart';
import 'package:final_year_die/services/auth.dart';
import 'package:final_year_die/shared/constant.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/firstTime.dart';

class SingIn extends StatefulWidget {
  final Function tukarPandangan;
  SingIn({this.tukarPandangan});

  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final _kunciForm = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  bool loading = false;
  String email = '';
  String password = '';
  dynamic error = '';
  String errMes = '';
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    MyApp.setLocale(context, _temp);
    final firstTime = Provider.of<FirstTime>(context, listen: false);
    firstTime.setPilihBhs(language.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    //final firstTime = Provider.of<FirstTime>(context);
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          getTranslated(context, 'welcome'),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.values[3],
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              getTranslated(context, 'paddy_sight'),
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              getTranslated(context, 'paddy_sight2'),
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow[600]),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Form(
                            key: _kunciForm,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  cursorColor: Colors.yellow,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Email'),
                                  validator: (val) => val.isEmpty
                                      ? getTranslated(context, 'email_error')
                                      : null,
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
                                      hintText:
                                          getTranslated(context, 'password')),

                                  validator: (val) => val.length < 8
                                      ? getTranslated(context, 'pass_error')
                                      : null, //? True : False
                                  obscureText: true,
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
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic keputusan = await _auth
                                            .signInWithEmail(email, password);

                                        if (keputusan == null) {
                                          setState(() {
                                            error = getTranslated(
                                                context, 'signin_error');

                                            loading = false;
                                          });
                                        }
                                      }
                                    },
                                    color: Colors.white,
                                    child: Text(
                                      getTranslated(context, 'login'),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      getTranslated(context, 'no_acc'),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        getTranslated(context, 'regnow'),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.yellow[600]),
                                      ),
                                      onPressed: () {
                                        widget.tukarPandangan();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  error ?? 'Entah',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ),
                                DropdownButton(
                                  onChanged: (Language language) {
                                    _changeLanguage(language);
                                  },
                                  hint: Text(
                                    getTranslated(context, 'lang'),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.language,
                                    color: Colors.yellow[600],
                                  ),
                                  underline: SizedBox(),
                                  items: Language.languageList()
                                      .map<DropdownMenuItem<Language>>((lang) =>
                                          DropdownMenuItem(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(lang.flag),
                                                Text(lang.name)
                                              ],
                                            ),
                                            value: lang,
                                          ))
                                      .toList(),
                                )
                              ],
                            )),
                      ],
                    )),
              ),
            ]),
          );
  }
}

class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇺🇸', 'English', 'en'),
      Language(2, '🇲🇾', 'Malaysia', 'ms')
    ];
  }
}

//Image.asset('', width: saiz.width , height: double.infinity, fit: BoxFit.fill,)
