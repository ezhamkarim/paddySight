import 'package:flutter/material.dart';

class PolygonData with ChangeNotifier {
  // final String _apiUrl =
  //     "http://api.agromonitoring.com/agro/1.0/polygons?appid=53d3f07fa4557b15df2ecda8aff79a42";

  // PolygonData();
  String polygonName;
  double area;
  String polygonID;
  Map<String, dynamic> geojsonCoors;
  bool checkCreatePoly;
//   http.Response response;
//   String _jsonRespon;
//   bool _isFetching = false;

//   bool get isFetching => _isFetching;

//   Future<void> fetchData(
//       Map<String, dynamic> polygonCoors, String polygonTitle) async {
//     _isFetching = true;
//     notifyListeners();

//     response = await http.post(_apiUrl,
//         headers: <String, String>{
//           "Content-Type": "application/json; charset=UTF-8",
//         },
//         body: jsonEncode(
//             <String, dynamic>{"name": polygonTitle, "geo_json": polygonCoors}));

//     if (response.statusCode == 201) {
//       print("BERJAYA");
//       _jsonRespon = response.body;
//     } else {
//       throw Exception('Failed to create polygon.');
//     }
//   }
// String get getResponseText => _jsonRespon;

//   List<dynamic>  getResponseJson(){
//     if(_jsonRespon.isNotEmpty){
//     Map<String, dynamic> json = jsonDecode(_jsonRespon);
//     return [json['id'],json['area'],json['geo_json']];

//     }
//     else{
//       return null;
//     }
//   }

  void setPolygonID(String id) {
    polygonID = id;
    notifyListeners();
  }

  // Future<void> setComplete(bool menyeset) {
  //   checkCreatePoly = menyeset;
  //   notifyListeners();
  // }

  bool get getComplete => checkCreatePoly;
  String get getPolygonID => polygonID;

  PolygonData({this.polygonName, this.area, this.geojsonCoors, this.polygonID});

  factory PolygonData.fromJson(Map<String, dynamic> json) {
    return PolygonData(
        polygonID: json['id'],
        area: json['area'],
        geojsonCoors: json['geo_json'],
        polygonName: json['name']);
  }
}

// class PolygonTelahDibuat{
//  String polygonName;
//   double area;
//   String polygonID;
//   Map<String,dynamic> geojsonCoors;
// PolygonTelahDibuat({this.polygonName,this.area,this.geojsonCoors,this.polygonID});

// }
