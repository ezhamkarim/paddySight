import 'package:final_year_die/localization/localization.dart';
import 'package:final_year_die/localization/localization_constant.dart';
import 'package:final_year_die/models/firstTime.dart';
import 'package:final_year_die/models/polygon.dart';
import 'package:final_year_die/models/user.dart';
import 'package:final_year_die/services/auth.dart';
import 'package:final_year_die/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:final_year_die/screens/wrapper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  //final User firstTime =User();
  // This widget is the root of your application.

  static void setLocale(BuildContext context, Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);

  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Locale _locale;

  void setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale){
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    if(_locale==null){
      return Loading();
    }
    else{
      return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        ChangeNotifierProvider<AuthService>(create: (_)=>AuthService()),
        ChangeNotifierProvider<FirstTime>(
          create: (_) => FirstTime(),
        ),
        ChangeNotifierProvider<PolygonData>(
          create: (_) => PolygonData(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Montserrat'),
        locale: _locale,
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        supportedLocales: [Locale('en', 'US'), Locale('ms', 'MY')],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocale){
          for (var locale in supportedLocale){
            if(locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode){
              return deviceLocale;
            }
          }
          return supportedLocale.first;
        },
      ),
    );
    }
  }
}
