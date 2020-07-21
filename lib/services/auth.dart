import 'package:final_year_die/models/firstTime.dart';
import 'package:final_year_die/models/user.dart';
import 'package:final_year_die/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AuthService {
// sign in anon
  final FirebaseAuth _auth = FirebaseAuth.instance;
  dynamic errorMessage;

//first time user bool

//create user OBBJECT base on firebase user
//pengunaFirebase method receive the argument and return a user object
// so now we have our own user obj to be use later on
// if that is pengguna pertama, return the User class with pengPer bool
  User _penggunaFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
// auth change service user stream
// Take a stream of firebase user and map into local user in _penggunaFirebase
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _penggunaFirebase(user));
  }

  Future signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      AuthResult keputusan = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser pengguna = keputusan.user;

      DatabaseService().setUserData(displayName, pengguna.uid);
      return _penggunaFirebase(pengguna);
    } catch (e) {
      print('error from sigin ' + e.toString());
      return null;
    }
  }

  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult keputusan = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser pengguna = keputusan.user;

      //Create  a document with id for the user
      //await DatabaseService(uid: pengguna.uid).updateUserData(' ');

      return _penggunaFirebase(pengguna);
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      print(errorMessage);
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      print('HALLO');
    } catch (e) {
      print(e.toString());
    }
  }
}
