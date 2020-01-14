

import 'package:flutter/material.dart';
import 'package:guia_unifei/home/homeList.dart';
import 'package:guia_unifei/qrCode/qrCode.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromRGBO(4, 88, 140, 1), const Color.fromRGBO(50, 121, 166, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => homeList()));
              },
              child: Text('Home',),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => qrCode()));
              },
              child: Text('Leitor QRCode',),
            ),

          ],
        ),
      ),
    );
  }
}