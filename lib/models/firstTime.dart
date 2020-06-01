import 'package:flutter/material.dart';

class FirstTime with ChangeNotifier{

  FirstTime();
  String err;
 bool firstTime= false; 
 bool dahPilihPadi = false;
 bool dahPilihMaps = false;
 bool dahPilihCalendar = false;
 bool pilihPageProfile = false;
String bahasa;
void setErr(String error){
  error = err;
  notifyListeners();
  print('Dalam setter'+error);
}

String get getErr=> err;

void setPilihBhs(String bhs){
  bahasa = bhs;
  notifyListeners();
  print('Dalam setter'+bahasa);
}

String get getBahasa=> bahasa;
void setProfileFirst(bool firs){
  pilihPageProfile = firs;
  notifyListeners();
  print('Dalam setter'+pilihPageProfile.toString());
  //nakTengok();
  
}
  bool get getProfilePage=>pilihPageProfile;

  void setFirstTime(bool firs){
  firstTime = firs;
  notifyListeners();
  print('Dalam setter'+firstTime.toString());
  //nakTengok();
  
}
  bool get getFirstTime=>firstTime;

  void setPilihPadi(bool firs){
    dahPilihPadi = firs;
    notifyListeners();

  }

  bool get getPilihPadi=>dahPilihPadi;

  void setPilihMaps(bool firs){
    dahPilihMaps = firs;
    notifyListeners();
  }

  bool get getPilihMaps=>dahPilihMaps;

 void setPilihCalendaer(bool firs){
    dahPilihCalendar = firs;
    notifyListeners();
  }

  bool get getPlihCalendar=>dahPilihCalendar;
}