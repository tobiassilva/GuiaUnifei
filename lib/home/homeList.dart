import 'package:flutter/material.dart';
import 'package:guia_unifei/local/locais.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class homeList extends StatefulWidget {
  @override
  _homeListState createState() => _homeListState();
}

class _homeListState extends State<homeList> {

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                //Navigator.pop(context);
              }
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)=> locaisList())
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text('Encontre por Locais', style: TextStyle(color: Colors.white, fontSize: 22),),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 250,
                width: 250,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  //myLocationEnabled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
