import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guia_unifei/app/local/LocaisDetalhes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guia_unifei/globals.dart' as globals;

class qrCode extends StatefulWidget {
  @override
  _qrCodeState createState() => _qrCodeState();
}

class _qrCodeState extends State<qrCode> {


  void initState(){
    super.initState();

  }

  int _counter = 0;
  Future<String> futureString;

  Future<void> _lerQrCode() async {

    if (await checkAndRequestCameraPermissions()) {
        futureString = new QRCodeReader()
            .setAutoFocusIntervalInMs(200) // default 5000
            .setForceAutoFocus(true) // default false
            .setTorchEnabled(true) // default false
            .setHandlePermissions(true) // default true
            .setExecuteAfterPermissionGranted(true) // default true
            .scan();
      print(await futureString);
      int id =  int.parse('${await futureString}');

      if(await futureString != null){
        for(int i=0; i<globals.jsonLocal['local'].length; i++){
          if(globals.jsonLocal['local'][i]['codigo'] == id){
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new locaisDetalhes(globals.jsonLocal['local'][i]),));
          }
        }

      }

      //print(futureString);
    }

    print('NAO EXISTE');

  }

  Future<bool> checkAndRequestCameraPermissions() async {
    print('PERMISION ssssssssssss');

    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    print('PERMISION: ${permissions.toString()}');
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    print('PERMISION ssssssssssss');
    if (permission != PermissionStatus.granted) {
      print('PERMISION false');
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      print('RETORNOU false');
      return permissions[PermissionGroup.camera] == PermissionStatus.granted;
    } else {
      print('PERMISION true');
      return true;
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black, size: 35,),
                      onPressed: (){
                        Navigator.pop(context);
                      }
                  ),
                ),
              ],
            ),
            Image.asset('assets/images/qrcode.jpg'),
            FlatButton(
              onPressed: (){
                _lerQrCode();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                height: 60,
                width: 170,
                decoration: BoxDecoration(
                    color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.qrcode, color: Colors.white, size: 28,),
                    Text('Ler QRCode', style: TextStyle(color: Colors.white, fontSize: 16),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _lerQrCode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), */
    );
  }
}
