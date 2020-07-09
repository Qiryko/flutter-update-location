import 'dart:io';

import 'package:app_scada/home.dart';
import 'trialend.dart';
// import 'package:app_scada/waktu.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'login.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:location_permissions/location_permissions.dart';
// import 'waktu.dart';

// Future<PermissionStatus> _getLocationPermission(
//       LocationPermissionLevel locationPermissionLevel) async {
//     final PermissionStatus permission = await LocationPermissions()
//         .checkPermissionStatus(level: locationPermissionLevel);

//     if (permission != PermissionStatus.granted) {
//       final PermissionStatus permissionStatus = await LocationPermissions()
//           .requestPermissions(permissionLevel: locationPermissionLevel);

//       return permissionStatus;
//     } else {
//       return permission;
//     }
//   }

String identifier;

class Data10 {
  String id;
  String imei;
  String plat;
  Data10({this.id, this.plat, this.imei});
}

Data data;
void main() async {
  identifier = await UniqueIdentifier.serial;
  var geoLocator = Geolocator();
  PermissionStatus permission =
      await LocationPermissions().requestPermissions();
  var status = await geoLocator.checkGeolocationPermissionStatus();

  if (status == GeolocationStatus.denied) {
    exit(0);
  }
  // Take user to permission settings
// else if (status == GeolocationStatus.disabled){

// }
//   // Take user to location page
// else if (status == GeolocationStatus.restricted){}
//   // Restricted
// else if (status == GeolocationStatus.unknown) {}
//   // Unknown
  else if (status == GeolocationStatus.granted) {
    String url =
        // 'http://192.168.43.215:8080/scada_api/public/api/loginawal';
        // 'http://192.168.0.45:8080/scada_api/public/api/loginawal';
        'http://182.253.112.110:2222/scada_api/public/api/loginawal';
    Map<String, String> headers = {"Content-type": "application/json"};
    String getlogin = '{"username": "${identifier}"}';
    Response response = await post(url, headers: headers, body: getlogin);
    int statusCode = response.statusCode;
    Map login = json.decode(response.body) as Map;
    identifier = await UniqueIdentifier.serial;
    data = Data(
        id: '${login['object_id']}',
        plat: '${login['plat']}',
        imei: identifier);
    if ('${login['keterangan']}' == "true") {
        runApp(MyApphome());
      // print(identifier);
    } else {
        runApp(MyApp());
    }
  }
}
// void main() {
// runApp(MyApp());

// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Scada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Login(),
    );
  }
}

class MyApphome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('${data.imei}');
    return MaterialApp(
      title: 'App Scada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Home( 
        data: data,
      ),
    );
  }
}

class MyAppTrial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Scada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Trial(),
    );
  }
} 