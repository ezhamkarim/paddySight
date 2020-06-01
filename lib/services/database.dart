import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_die/models/accountList.dart';
import 'package:final_year_die/models/inventoryList.dart';
import 'package:final_year_die/models/jadualList.dart';
import 'package:final_year_die/models/plants.dart';
import 'package:final_year_die/models/satelliteImagery.dart';
import 'package:final_year_die/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection referrence
  final CollectionReference plantCollection =
      Firestore.instance.collection('padiPengguna');

  final CollectionReference accountCollection =
      Firestore.instance.collection('akaunPengguna');
  final CollectionReference inventoriCollection =
      Firestore.instance.collection('inventoriPengguna');
  final CollectionReference satImageCollection =
      Firestore.instance.collection('satPengguna');
  final CollectionReference jadualPadi =
      Firestore.instance.collection('jadualPadi');
      final CollectionReference userData =
      Firestore.instance.collection('userData');
  //DocumentReference documentReference = Firestore.instance.collection('padiPengguna').document(uid);
  
  Future setUserData(String name, String userID) async{
    return await userData.document(userID).setData({
      'displayName': name,
      'lastSeen': DateTime.now().toLocal()

    });
  }
  
  
  Future updateUserData(String plantName) async {
    return await plantCollection.document(uid).setData(
        {'plantName': plantName},
        merge: true);
  }

  Future tambahUserData(
      String polygon, String locationLat, String locationLong, String near) async {
    return await plantCollection.document(uid).setData({
      'polygon': polygon,
      'location latitude': locationLat,
      'location longitude': locationLong,
      'near location': near
    }, merge: true);
  }

  Future tambahPolyData(
      String polygonID, String polygonNama, double area, String geoJson) async {
    return await plantCollection.document(uid).setData({
      'polygonID': polygonID,
      'polygonName': polygonNama,
      'area': area,
      'geo_json': geoJson
    }, merge: true);
  }

  Future tambahFirstAccount() async {
    return await accountCollection.document(uid).setData({
      'account_details': [],
      'totalExpense': 0.0,
      'totalRevenue': 0.0,
    });
  }

  Future tambahFirstInventory() async {
    return await inventoriCollection
        .document(uid)
        .setData({'machinery': [], 'tools': [], 'crop': []});
  }

  Future tambahFirstSatelliteImage() async {
    return await satImageCollection.document(uid).setData({
      'falseColor': '',
      'trueColor': '',
      'evi': '',
      'ndvi': '',
    });
  }

  Future tambahImage(
      String ndvi, String evi, String falseColor, String trueColor) async {
    return await satImageCollection.document(uid).updateData({
      'trueColor': trueColor,
      'falseColor': falseColor,
      'evi': evi,
      'ndvi': ndvi,
    });
  }

  Future tambahInventory(
      {Map<String, dynamic> addMachinery,
      Map<String, dynamic> addCrop,
      Map<String, dynamic> addTools}) async {
    if (addMachinery != null) {
      return await inventoriCollection.document(uid).updateData({
        'machinery': FieldValue.arrayUnion([addMachinery]),
      });
    } else if (addCrop != null) {
      return await inventoriCollection.document(uid).updateData({
        'crop': FieldValue.arrayUnion([addCrop]),
      });
    } else {
      return await inventoriCollection.document(uid).updateData({
        'tools': FieldValue.arrayUnion([addTools]),
      });
    }
  }

  Future tambahAccount(Map<String, dynamic> addAccount,
      {double totalExpense, double totalRevenue}) async {
    return await accountCollection.document(uid).updateData({
      'account_details': FieldValue.arrayUnion([addAccount]),
      'totalExpense': FieldValue.increment(totalExpense),
      'totalRevenue': FieldValue.increment(totalRevenue),
    });
  }

  Future tambahJadualPadi(Map<String,dynamic> jadual, DateTime startTime) async{
    return await jadualPadi.document(uid).setData({
      'jadual': jadual,
      'startTime' : startTime
    });

  }

  AccountList _accountListFromSnapshots(DocumentSnapshot snapshot) {
    return AccountList(
        accountList: snapshot.data['account_details'],
        totalRevenue: snapshot.data['totalRevenue'],
        totalExpense: snapshot.data['totalExpense']);
  }

  Stream<AccountList> get accountData {
    return accountCollection.document(uid).snapshots().map(
        (DocumentSnapshot snapshot) => _accountListFromSnapshots(snapshot));
  }

  Plants _plantsDataFromSnapshots(DocumentSnapshot snapshot) {
    return Plants(
        uid: uid,
        plantName: snapshot.data['plantName'],
        polygonName: snapshot.data['polygonName'],
        locationLat: snapshot.data['location latitude'],
        locationLong: snapshot.data['location longitude'],
        polygonID: snapshot.data['polygonID'],
        area : snapshot.data['area'],
        near : snapshot.data['near location']
        );

  }

  Stream<Plants> get plantData {
    return plantCollection
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => _plantsDataFromSnapshots(snapshot));
  }

  InventoryList _inventoryListDataFromSnapshot(DocumentSnapshot snapshot) {
    return InventoryList(
        crop: snapshot.data['crop'],
        tools: snapshot.data['tools'],
        machinery: snapshot.data['machinery']);
  }

  Stream<InventoryList> get inventoryData {
    return inventoriCollection.document(uid).snapshots().map(
        (DocumentSnapshot snapshot) =>
            _inventoryListDataFromSnapshot(snapshot));
  }

  Satellite _satelliteData(DocumentSnapshot snapshot) {
    return Satellite(
        evi: snapshot.data['evi'],
        ndvi: snapshot.data['ndvi'],
        falseColor: snapshot.data['falseColor'],
        trueColor: snapshot.data['trueColor']);
  }

  Stream<Satellite> get satData {
    return satImageCollection
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => _satelliteData(snapshot));
  }

  JadualList _jadualData(DocumentSnapshot snapshot) {
    Map takConver = snapshot.data['jadual'];
    final convert = takConver.map((key, value)
       => MapEntry<DateTime, List>(DateTime.parse(key), value)
    );

    return JadualList(
    events: convert,
    startTime: (snapshot.data['startTime'] as Timestamp).toDate(),
    );
  }

  Stream<JadualList> get jadualData {
    return jadualPadi
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => _jadualData(snapshot));
  }
  User _userName(DocumentSnapshot snapshot){
    return User(
      name: snapshot.data['displayName']
    );
  }
  Stream<User> get userName {
    return userData.document(uid).snapshots()
        .map((DocumentSnapshot snapshot) => _userName(snapshot));
  }
}
