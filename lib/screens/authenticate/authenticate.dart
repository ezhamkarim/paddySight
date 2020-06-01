import 'package:final_year_die/screens/authenticate/register.dart';
import 'package:final_year_die/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  
  void tukarPandangan(){
    setState(() {
      showSignIn=!showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    
   if (showSignIn) {
     return SingIn( tukarPandangan : tukarPandangan);
   } else {
     return Register(tukarPandangan : tukarPandangan);
   }
  }
}