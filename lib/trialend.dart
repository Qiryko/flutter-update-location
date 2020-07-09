import 'dart:io';

import 'package:flutter/material.dart';

class Trial extends StatefulWidget {
  @override
  _TrialState createState() => _TrialState();
}

class _TrialState extends State<Trial> {
  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: CircleAvatar(
                radius: 150.0,
                backgroundColor: Colors.transparent,
                child: Image.asset('images/tower.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('Mohon maaf!',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('masa trial anda telah habis',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('Silahkan hubungi pihak pengembang',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 30.0),
              child: new Text('untuk dapat menjalankan aplikasi',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                     exit(0);
                    },
                    heroTag: 'dis',
                    splashColor: Colors.blue,
                    label:
                        Text('Tutup Aplikasi', style: TextStyle(color: Colors.white)),
                   
                    backgroundColor: Color.fromRGBO(20, 159, 182, 100),
                    // backgroundColor: Colors.blue,
                    elevation: 0.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}