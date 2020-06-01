import 'package:final_year_die/models/user.dart';
import 'package:final_year_die/screens/authenticate/authenticate.dart';
import 'package:final_year_die/screens/authenticate/choosePlant.dart';
import 'package:flutter/material.dart';
import 'package:final_year_die/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:final_year_die/models/firstTime.dart';



class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<User>(context);
    final firstTime = Provider.of<FirstTime>(context);
    //print(pengguna);
    // return either home or auth widget
    if (pengguna == null) {
      return Authenticate();
    } else {
        if(firstTime.getFirstTime){
        return ChoosePlant();
        }
        else{
          return Home();
        }
        
        //return Home();
      }
      
    }
  }

