import 'package:flutter/material.dart';

class Satellite with ChangeNotifier {
  String trueColor;
  String falseColor;
  String ndvi;
  String evi;
  dynamic images;
  String errors;

  Satellite(
      {this.trueColor, this.falseColor, this.ndvi, this.evi, this.images});

  factory Satellite.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return Satellite();
    } else {
      return Satellite(
          trueColor: json[0]["image"]['truecolor'],
          falseColor: json[0]["image"]["falsecolor"],
          ndvi: json[0]["image"]["ndvi"],
          evi: json[0]["image"]["evi"]);
    }
  }

  Satellite.errorHandle(String error) {
    errors = error;
    print(errors + 'hello kt dlm error handler');
    notifyListeners();
  }

  String get newError => errors;
}
