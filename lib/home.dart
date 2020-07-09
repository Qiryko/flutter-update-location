import 'dart:io';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'jarak.dart';
import 'waktu.dart';
import 'login.dart';
import 'dart:convert';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class Home extends StatefulWidget {
  static String tag = 'Home';
  final Data data;
  Home({this.data});
  // static String plat = '${data.plat}';

  @override
  _HomeState createState() => _HomeState(data: data);
}

class Data1 {
  String id;
  String imei;
  String plat;
  Data1({this.id, this.imei, this.plat});
}

class _HomeState extends State<Home> {
  final Data data;
  _HomeState({this.data});
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
    print("BACK BUTTON!"); // Do some stuff.
    Alert(
            context: context,
            type: AlertType.warning,
            title: "warning",
            desc: "tidak bisa kembali, silahkan logout")
        .show();
    //  _positionStreamSubscription?.cancel();
    //  locationOptions = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    // pr.style(message: 'Mohon tunggu...');

    //Optional
    pr.style(
      message: 'Mohon tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return new Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: const DecorationImage(
        //     image: AssetImage('images/background.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 300.0, top: 30),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  pr.show();
                  String identifier = await UniqueIdentifier.serial;
                  String url =
                      'http://182.253.112.110:2222/scada_api/public/api/logout';
                  // String url =
                  //     'http://192.168.43.215:8080/scada_api/public/api/logout';
                  // 'http://192.168.0.45:8080/scada_api/public/api/logout';
                  Map<String, String> headers = {
                    "Content-type": "application/json"
                  };
                  String getlogin = '{"username": "${identifier}"}';
                  Response response =
                      await post(url, headers: headers, body: getlogin);
                  int statusCode = response.statusCode;
                  Map login = json.decode(response.body) as Map;
                  Future.delayed(Duration(seconds: 2)).then((onValue) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                    
                  }); pr.hide();
                },
                heroTag: 'log',
                elevation: 0,
                label:
                    Icon(Icons.settings_power, color: Colors.red, size: 40.0),
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: CircleAvatar(
                radius: 150.0,
                backgroundColor: Colors.transparent,
                child: Image.asset('images/tower.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('Selamat Datang',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: new Text('${data.plat}',
                  style: TextStyle(fontSize: 30, color: Colors.black)),
            ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      dispose();
                      // BackButtonInterceptor.remove(myInterceptor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Jarak(data: widget.data)),
                      );
                    },
                    heroTag: 'dis',
                    splashColor: Colors.blue,
                    label:
                        Text('Distance', style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.directions_car, color: Colors.white),
                    backgroundColor: Color.fromRGBO(20, 159, 182, 100),
                    // backgroundColor: Colors.blue,
                    elevation: 0.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      dispose();
                      // BackButtonInterceptor.remove(myInterceptor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Waktu(data: widget.data)),
                      );
                    },
                    heroTag: 'int',
                    splashColor: Colors.blue,
                    label:
                        Text('Interval', style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.timer, color: Colors.white),
                    elevation: 0.0,
                    backgroundColor: Color.fromRGBO(20, 159, 182, 100),
                    // backgroundColor: Colors.blue,
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
