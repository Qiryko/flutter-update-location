import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'home.dart';
import 'dart:convert';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class Login extends StatefulWidget {
  static String tag = 'Login';

  @override
  _LoginState createState() => new _LoginState();
}

class Data {
  String id;
  String imei;
  String plat;
  Data({this.id, this.imei, this.plat});
}

class _LoginState extends State<Login> {
  bool _isTextFieldVisible = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String identifier;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(message: 'Mohon tunggu...');

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
    _usernameController.text = identifier;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: screenHeight,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(top: screenHeight / 5),
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 85),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/logo.png",
                                width: 340.0,
                                height: 120.0,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              _isTextFieldVisible
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: TextFormField(
                                        controller: _usernameController,
                                        enabled: false,
                                        decoration: InputDecoration(
                                            labelText: "Device ID",
                                            hasFloatingPlaceholder: true),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20,
                                    ),
                              RaisedButton(
                                child: Text(_isTextFieldVisible
                                    ? "Sembunyikan"
                                    : "Tampilkan device ID"),
                                onPressed: () async {
                                  identifier = await UniqueIdentifier.serial;
                                  setState(() => _isTextFieldVisible =
                                      !_isTextFieldVisible);
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    hasFloatingPlaceholder: true),
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(),
                                  ),
                                  FlatButton(
                                    child: Text("Log in"),
                                    color: Color.fromRGBO(20, 162, 186, 100),
                                    textColor: Colors.white,
                                    padding: EdgeInsets.only(
                                        left: 115,
                                        right: 115,
                                        top: 15,
                                        bottom: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () async {
                                      pr.show();

                                      identifier =
                                          await UniqueIdentifier.serial;
                                      String url =
                                          'http://182.253.112.110:2222/scada_api/public/api/login';
                                      // String url =
                                      //     'http://192.168.43.215:8080/scada_api/public/api/login';
                                      Map<String, String> headers = {
                                        "Content-type": "application/json"
                                      };
                                      String getlogin =
                                          '{"username": "${_usernameController.text}","password": "${_passwordController.text}"}';
                                      Response response = await post(url,
                                          headers: headers, body: getlogin);
                                      int statusCode = response.statusCode;
                                      Map login =
                                          json.decode(response.body) as Map;
                                      identifier =
                                          await UniqueIdentifier.serial;
                                      final data = Data(
                                          id: '${login['object_id']}',
                                          plat: '${login['plat']}',
                                          imei: identifier);
                                      if ('${login['keterangan']}' == "true") {
                                        // Alert(context: context, title: "Success", desc: "Login Succesful").show();
                                        // print('${data.imei}');
                                        Future.delayed(Duration(seconds: 2))
                                            .then((onValue) {
                                          pr.hide();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home(
                                                      data: data,
                                                    )),
                                          );
                                        });
                                      } else {
                                        pr.hide();
                                        Alert(
                                          context: context,
                                          type: AlertType.error,
                                          title: "Login Gagal",
                                          desc:
                                              "Password salah atau akun belum terdaftar!",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()),
                                                );
                                              },
                                              width: 120,
                                            )
                                          ],
                                        ).show();
                                        // print('${login['keterangan']}');
                                        // print('${data.imei}');
                                        // print(identifier);
                                        // print(uuid);

                                      }
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
