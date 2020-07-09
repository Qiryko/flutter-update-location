import 'dart:async';
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'login.dart';
// import 'package:background_fetch/background_fetch.dart';
import 'ambilwaktu.dart';
import 'home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

// getCurrentLocation() {
//   BackgroundLocation().getCurrentLocation().then((location) async {
//     String url = 'http://172.20.10.3/scada_api/public/api/lokasi';
//     Map<String, String> headers = {"Content-type": "application/json"};
//     String json =
//         '{"longitude": "${location.longitude}","latitude": "${location.latitude}"}';
//     Response response = await post(url, headers: headers, body: json);
//     print(response);
//   });
//   // print("This is current Location" + location.longitude.toString());
// }

// void backgroundFetchHeadlessTask() async {
//   getCurrentLocation();
// }

class Waktu extends StatefulWidget {
  final Data data;
  Waktu({this.data});

  @override
  _WaktuState createState() => _WaktuState(data: data);
}

class Data3 {
  String id;
  String imei;
  String plat;
  String input;
  Data3({this.id, this.input, this.imei, this.plat});
}

class _WaktuState extends State<Waktu> {
  StreamSubscription<Position> _positionStreamSubscription;
  LocationOptions locationOptions;
  // Stream<Position> positionStream;
  final List<Position> _positions = <Position>[];
  Position _position;
  String body;
  String body2;
  bool back = true;
  Geolocator geolocatorperm = Geolocator()..forceAndroidLocationManager = true;

  void checkPermission() {
    geolocatorperm.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    geolocatorperm
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    geolocatorperm.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    if (back == true) {
      dispose();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home(data: widget.data)),
      );
    } else {
      print("BACK BUTTON!"); // Do some stuff.
      Alert(
              context: context,
              title: "warning",
              desc: "tidak bisa kembali, silahkan stop")
          .show();
      //  _positionStreamSubscription?.cancel();
      //  locationOptions = null;
    }

    return true;
  }
// checkPermission();

  List<String> _colors = <String>['10', '20', '30', '50', '80'];
  // List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '10';
  final Data data;
  // int _status = 0;
  _WaktuState({this.data});

// @override
//   void initState() {
//     super.initState();
//     geolocatorperm = Geolocator();
//     LocationOptions locationOptions =
//         LocationOptions(accuracy: LocationAccuracy.high, timeInterval: 10);
//     // checkPermission();
//     StreamSubscription positionStream = geolocatorperm
//         .getPositionStream(locationOptions)
//         .listen((Position position) {});
//   }
  // void updateLocation() async {
  //   String id2 = '${data.imei}';
  //   try {
  //     Position newPosition = await Geolocator()
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //         .timeout(new Duration(seconds: 5));
  //     // String url = 'https://jsonplaceholder.typicode.com/posts';
  //      String url = 'http://182.253.112.110:2222/scada_api/public/api/lokasi';
  //     Map<String, String> headers = {"Content-type": "application/json"};
  //     // String json =
  //     //     '{"title": "${_position.longitude}","body": "${_position.latitude}"}';
  //     // String url = 'https://127.0.0.1:8000/api/lokasi';
  //     // Map<String, String> headers = {"Content-type": "application/json"};
  //     String json =
  //         '{"longitude": "${_position.longitude}","latitude": "${_position.latitude}","device_id": "${id2}"}';

  //     Response response = await post(url, headers: headers, body: json);
  //     int statusCode = response.statusCode;
  //     body = response.body;

  //     setState(() {
  //       _position = newPosition;
  //     });
  //   } catch (e) {
  //     print('Error: ${e.toString()}');
  //   }
  // }
  // final _waktuController = TextEditingController();

  // void initState() {
  //   super.initState();

  //   BackgroundLocation.startLocationService();
  //   BackgroundLocation.getLocationUpdates((location) {
  //     setState(() async {
  //       String url = 'http://172.20.10.3/scada_api/public/api/lokasi';
  //       Map<String, String> headers = {"Content-type": "application/json"};
  //       String json =
  //           '{"longitude": "${location.longitude}","latitude": "${location.latitude}"}';
  //       Response response = await post(url, headers: headers, body: json);
  //       print(response);
  //     });
  //   });
  // }

  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   BackgroundFetch.configure(
  //       BackgroundFetchConfig(
  //         minimumFetchInterval: 15,
  //         stopOnTerminate: false,
  //         enableHeadless: false,
  //       ), () async {
  //     getCurrentLocation();
  //     BackgroundFetch.finish();
  //     // This is the
  //   }).then((int status) {
  //     print('[BackgroundFetch] configure success: $status');
  //     setState(() {
  //       _status = status;
  //     });
  //   }).catchError((e) {
  //     print('[BackgroundFetch] configure ERROR: $e');
  //     setState(() {
  //       _status = e;
  //     });
  //   });

  //   // Optionally query the current BackgroundFetch status.
  //   int status = await BackgroundFetch.status;
  //   setState(() {
  //     _status = status;
  //   });

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  // }

  @override
  void _toggleListening() async {
    int number = int.parse(_color) * 1000;
    String id = '${data.imei}';

    geolocatorperm = new Geolocator();
    locationOptions = new LocationOptions();
    // _positionStreamSubscription = null;
    back = false;
    if (_positionStreamSubscription == null) {
      locationOptions = LocationOptions(
          accuracy: LocationAccuracy.best, timeInterval: number);
      checkPermission();
      Stream<Position> positionStream =
          geolocatorperm.getPositionStream(locationOptions);

      _positionStreamSubscription =
          positionStream.listen((Position position) async {
        _position = position;
        print("cek");
        // String url = 'http://192.168.100.80/scada_api/public/api/lokasi';
        String url = 'http://182.253.112.110:2222/scada_api/public/api/lokasi';
        Map<String, String> headers = {"Content-type": "application/json"};
        String json =
            '{"longitude": "${_position.longitude}","latitude": "${_position.latitude}","device_id": "${id}"}';
        // '{"longitude": "${_position.longitude}","latitude": "${_position.latitude}"}';
        // String url = 'https://jsonplaceholder.typicode.com/posts';
        // Map<String, String> headers = {"Content-type": "application/json"};
        // String json =
        //     '{"title": "${_position.longitude}","body": "${_position.latitude}"}';

        Response response = await post(url, headers: headers, body: json);
        int statusCode = response.statusCode;
        print("cek2");
        body = locationOptions.distanceFilter.toString();
        body2 = locationOptions.timeInterval.toString();
        print(body);
        print(body2);
        setState(() {
          body = locationOptions.distanceFilter.toString();
          body2 = locationOptions.timeInterval.toString();
          print(body);
          print(body2);
        });

        // body = response.body;
      });
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
    // SystemNavigator.pop();
    await SystemShortcuts.home();
  }

  //   @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<GeolocationStatus>(
  //       future: Geolocator().checkGeolocationPermissionStatus(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
  //         if (!snapshot.hasData) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         return _buildListView();
  //       });
  // }

  Widget _buildListView() {
    final List<Widget> listItems = <Widget>[
      ListTile(
        title: RaisedButton(
          child: _buildButtonText(),
          color: _determineButtonColor(),
          padding: const EdgeInsets.all(8.0),
          onPressed: _toggleListening,
        ),
      ),
    ];
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Widget _buildButtonText() {
    return Text(_isListening() ? 'Stop' : 'Start');
  }

  Color _determineButtonColor() {
    return _isListening() ? Colors.red : Colors.green;
  }

//   class PositionListItem extends StatefulWidget {
//   const PositionListItem(this._position);

//   final Position _position;

//   @override
//   State<PositionListItem> createState() => PositionListItemState(_position);
// }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: screenWidth,
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: const DecorationImage(
        //     image: AssetImage('images/background.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // color: Color.fromRGBO(20, 162, 186, 100),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0, bottom: 10.0),
              child: CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.transparent,
                child: Image.asset('images/interval.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('TIME INTERVAL',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: new Text('Silahkan memilih',
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Text('waktu yang akan digunakan',
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
              child: new Text('dengan satuan detik',
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
            back
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Container(
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromRGBO(20, 162, 186, 100),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          child: DropdownButton(
                            style: TextStyle(
                                color: Color.fromRGBO(20, 162, 186, 100),
                                fontSize: 25),
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                // newContact.favoriteColor = newValue;
                                _color = newValue;
                                // state.didChange(newValue);
                              });
                            },
                            items: _colors.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Container(
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromRGBO(20, 162, 186, 100),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          child: new Text(_color,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(20, 162, 186, 100))),
                        ),
                      ),
                    ),
                  ),

            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
            //   child: new Text(_color,
            //       style: TextStyle(fontSize: 25, color: Color.fromRGBO(20, 162, 186, 100))),
            // ),

            //        ListTile(
            //   title: RaisedButton(
            //     child: _buildButtonText(),
            //     color: _determineButtonColor(),
            //     padding: const EdgeInsets.all(8.0),
            //     onPressed: _toggleListening,
            //   ),
            // ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                back
                    ? Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: screenWidth / 8, right: screenWidth / 8),
                          child: FloatingActionButton.extended(
                            onPressed: _toggleListening,
                            heroTag: 'dis',
                            label: Padding(
                              padding: const EdgeInsets.only(
                                  left: 90.0, right: 90.0),
                              child: Text('Start',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            ),
                            // icon: Icon(Icons.plus, color: Colors.white),
                            backgroundColor: Color.fromRGBO(20, 159, 182, 100),
                            elevation: 0,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: screenWidth / 8, right: screenWidth / 8),
                          child: FloatingActionButton.extended(
                            onPressed: () => exit(0),
                            heroTag: 'int',
                            label: Padding(
                              padding: const EdgeInsets.only(
                                  left: 90.0, right: 90.0),
                              child: Text('Stop',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            ),
                            // icon: Icon(Icons.timer, color: Colors.white),
                            backgroundColor: Colors.red,
                            elevation: 0,
                          ),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
