import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guia_unifei/local/LocaisDetalhes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guia_unifei/mapa.dart';
import 'package:localstorage/localstorage.dart';

class locaisList extends StatefulWidget {
  @override
  _locaisListState createState() => _locaisListState();
}

final LocalStorage storage = new LocalStorage("json");

class _locaisListState extends State<locaisList> {

  void initState(){
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return /*MaterialApp(
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
        body:*/ Container(
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
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20.0, // has the effect of softening the shadow
                              spreadRadius: 2.0, // has the effect of extending the shadow
                              offset: Offset(
                                10.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                          
                        ),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: (){
                            Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new locaisDetalhes(globals.jsonLocal['local'][index]),));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                  child: Image(image: new CachedNetworkImageProvider("${globals.jsonLocal['local'][index]['imgcapa']}"),/*Image.network('${globals.jsonLocal['local'][index]['imgcapa']}',*/
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text('${globals.jsonLocal['local'][index]['nome']}',
                                      style: TextStyle(),),
                                    ],
                                  ),
                                ),
                              ),

                              FlatButton(
                                padding: EdgeInsets.only(left: 15, top: 0, right: 0),
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
                                    width: 88,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                                      color: Colors.blue,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: new BorderRadius.circular(30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.map, color: Colors.white, size: 30,),
                                          Flexible(
                                            child: Text('como', textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text('chegar', textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
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
        //),
      //),
    );
  }

}
