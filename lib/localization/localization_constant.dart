import 'package:final_year_die/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslated(BuildContext context, String key){
  return DemoLocalization.of(context).getTranslatedValue(key);


}

const String ENGLISH = 'en';
const String MALAY = 'ms';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}


Locale _locale (String languageCode){
  Locale _temp; 
    
    switch (languageCode){
      case ENGLISH :
      _temp = Locale(languageCode, 'US');
      break;
      case MALAY :
      _temp = Locale(languageCode, 'MY');
       break;
       default  :
      _temp = Locale(ENGLISH, 'US');
    }

    return _temp;
}

Future<Locale> getLocale() async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String _languageCode = _prefs.getString(LANGUAGE_CODE)?? ENGLISH;

  return _locale(_languageCode);
}
