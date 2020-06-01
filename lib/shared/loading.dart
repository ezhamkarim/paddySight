import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin{
  AnimationController controller;
  @override
 
 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SpinKitRotatingPlain(
        color: Colors.green,
        size: 50,
        controller: AnimationController(duration: Duration(seconds: 2), vsync: this),
      ),
    );
  }
}