import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'waktu.dart';

class GeoListenPage extends StatefulWidget {
  final Data3 data;
  GeoListenPage({this.data});
  @override
  _GeoListenPageState createState() => _GeoListenPageState(
    data: data
  );
}

class _GeoListenPageState extends State<GeoListenPage> {
  final Data3 data;
  _GeoListenPageState({this.data});

  Geolocator geolocator;
  Position _position;
  String body;
  void checkPermission() {
    geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();
    geolocator = Geolocator();
    int number = int.parse('${data.input}')*1000; 
    String id = '${data.imei}';
    // int imei = int.parse('${data.imei}'); 
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, timeInterval: number);
        // LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    checkPermission();

    StreamSubscription positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      _position = position;
      String url = 'http://192.168.100.80/scada_api/public/api/lokasi';
      // String url = 'http://182.253.112.110:2222/scada_api/public/api/lokasi';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json =
          // '{"longitude": "${_position.longitude}","latitude": "${_position.latitude}","device_id": "${id}"}';
          '{"longitude": "${_position.longitude}","latitude": "${_position.latitude}"}';
      // String url = 'https://jsonplaceholder.typicode.com/posts';
      // Map<String, String> headers = {"Content-type": "application/json"};
      // String json =
      //     '{"title": "${_position.longitude}","body": "${_position.latitude}"}';

      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      setState(() {
        body = number.toString();
      });
      
      // body = response.body;
    });
    SystemNavigator.pop();
  }

  void updateLocation() async {
    String id2 = '${data.imei}';
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      // String url = 'https://jsonplaceholder.typicode.com/posts';
       String url = 'http://182.253.112.110:2222/scada_api/public/api/lokasi';
      Map<String, String> headers = {"Content-type": "application/json"};
      // String json =
      //     '{"title": "${_position.longitude}","body": "${_position.latitude}"}';
      // String url = 'https://127.0.0.1:8000/api/lokasi';
      // Map<String, String> headers = {"Content-type": "application/json"};
      String json =
          '{"longitude": "${_position.longitude}","latitude": "${_position.latitude}","device_id": "${id2}"}';
          

      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      body = response.body;

      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INTERVAL',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(20, 162, 186, 100),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(20, 162, 186, 100),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 25.0),
                child: new Center(
                  child: new Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, bottom: 10.0, left: 30.0, right: 30.0),
                    child: Column(
                      children: <Widget>[
                        new Icon(
                          Icons.timer,
                          color: Color.fromRGBO(20, 162, 186, 100),
                          size: 90,
                        ),
                        new Text('Mode Interval',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(20, 162, 186, 100))),
                        new Card(
                          margin: EdgeInsets.only(
                              top: 30.0, left: 40.0, right: 40.0, bottom: 10.0),
                          color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            new Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: RaisedButton(
                      elevation: 10,
                      splashColor: Color.fromRGBO(20, 162, 186, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        
                      },
                      padding: EdgeInsets.only(
                          top: 20.0, left: 45.0, right: 45.0, bottom: 20.0),
                      color: Colors.redAccent,
                      child: Text('Stop Tracking',
                          style: TextStyle(
                              fontSize: 30,
                              color: Color.fromRGBO(20, 162, 186, 100))),
                    ),
                  ),
              
                ],
              ),
            )
          ],
        ),
      ),
    
          //   'Response: ${body},'
          //     'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
          //     ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}')),
    );
  }
}
