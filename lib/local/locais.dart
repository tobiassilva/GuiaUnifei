import 'package:flutter/material.dart';
import 'package:guia_unifei/local/LocaisDetalhes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guia_unifei/mapa.dart';

class locaisList extends StatefulWidget {
  @override
  _locaisListState createState() => _locaisListState();
}

class _locaisListState extends State<locaisList> {


  Completer<GoogleMapController> _controllerMaps = Completer();


  void initState(){
    super.initState();

  }

  MapType _currentMapType = MapType.satellite;
  void _criarMap(GoogleMapController controller) {
    _controllerMaps.complete(controller);
  }

  List<Marker> marcadorMaps = [];

  List<Marker> atualizaMarcador(double latitudeLocal, double longitudeLocal) {
    marcadorMaps.clear();
    marcadorMaps.add(Marker(
        markerId: MarkerId('Marcador'),
        draggable: false,
        onTap: () {
          print('Market Tapped');
        },
        position: LatLng(latitudeLocal, longitudeLocal)));

    return marcadorMaps;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, right: 5),
                //color: Colors.blue,
                child: globals.jsonLocal == null ? Center(
                  child: SpinKitCubeGrid(
                    color: Colors.lightBlue,
                  ),
                ) :
                ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: globals.jsonLocal['local'].length,
                    itemBuilder: (BuildContext context, index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                          
                        ),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: (){
                            Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new locaisDetalhes(globals.jsonLocal['local'][index]),));
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    //color: Colors.red
                                ),
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(30),
                                  child: Image.network('${globals.jsonLocal['local'][index]['imgcapa']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text('${globals.jsonLocal['local'][index]['nome']}'),
                                    ],
                                  ),
                                ),
                              ),

                              FlatButton(
                                padding: EdgeInsets.only(left: 15, top: 0, ),
                                  onPressed: (){
                                    setState(() {
                                      Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (context) => new mapaPage(
                                          globals.jsonLocal['local'][index]['nome'],
                                            globals.jsonLocal['local'][index]['latitude'],
                                            globals.jsonLocal['local'][index]['longitude']
                                        ),));
                                      //_mapaDialog(globals.jsonLocal['local'][index]);
                                    });
                                  },
                                  child: Container(
                                    height: 120,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                                      color: Colors.blue,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.map, color: Colors.white, size: 30,),
                                        Flexible(
                                          child: Text('como chegar', textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                        //Text('Item $index: ${jsonLocal['local'][index]['historia']}'),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
  }

  Future<void> _mapaDialog(var jsonItemEscolhido) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MaterialApp(
          home: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                margin: EdgeInsets.fromLTRB(30, 55, 30, 50),
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(13, 32, 45, 1),
                    border: new Border.all(
                      width: 1.0,
                      color: Colors.transparent,
                    ),
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(20.0))),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(0, 185, 255, 1),
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                                IconData(57676, fontFamily: 'MaterialIcons')),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.7,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            onMapCreated: _criarMap,
                            myLocationEnabled: true,
                            mapType: _currentMapType,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    jsonItemEscolhido['latitude'],
                                    jsonItemEscolhido['longitude']),
                                zoom: 16.0),
                            markers: Set.from(atualizaMarcador(
                                jsonItemEscolhido['latitude'],
                                jsonItemEscolhido['longitude'])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                onPressed: _onMapTypeButtonPressed,
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                backgroundColor: Colors.green,
                                child: const Icon(Icons.map, size: 36.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    jsonItemEscolhido['nome'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 185, 255, 1),
                                      fontSize: 15.0,
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    'Local: ${jsonItemEscolhido['nome']}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 1, left: 30, right: 30),
                            margin: EdgeInsets.only(
                                left: 0, right: 100, top: 15, bottom: 15),
                            decoration: new BoxDecoration(
                                color: Color.fromRGBO(0, 185, 255, 1),
                                border: new Border.all(
                                  width: 1.0,
                                  color: Colors.transparent,
                                ),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0))),
                            alignment: Alignment.center,
                          ),



                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

}
