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

  List locaisEsc = List();
  var tipoLocaisEsc;
  var jsonLocaisAux;
  void initState(){
    super.initState();

  }

  Future<String> filtroLocal(var escolhido){

    locaisEsc.clear();

    setState(() {
      print(escolhido);

      if(escolhido == null){
        tipoLocaisEsc = escolhido;
      } else {
        jsonLocaisAux = escolhido['nome'];
        tipoLocaisEsc = escolhido['codigo'];
      }

      print('tipoLocaisEsc:  $tipoLocaisEsc');

      if(tipoLocaisEsc != null){


        for(int i = 0; i < globals.jsonLocal['local'].length; i++){
          print('globals.jsonLocal: ${globals.jsonLocal['local'][i]['codtlocal']}');
          if(globals.jsonLocal['local'][i]['codtlocal'] == tipoLocaisEsc){
            locaisEsc.add(globals.jsonLocal['local'][i]);

          }
        }
        print(locaisEsc);
        print(locaisEsc.length);
      } else {

      }


    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
          child: ListView(
            children: <Widget>[

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                //padding: EdgeInsets.only(left: 15, right: 5),
                //color: Colors.blue,
                child: globals.jsonLocal == null ? Center(
                  child: SpinKitCubeGrid(
                    color: Colors.lightBlue,
                  ),
                ) :
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Divider(
                      height: 210,
                    ),

                    Container(
                      height: 30,
                      margin: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
                      child:  tipoLocaisEsc == null ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: globals.jsonTipoLocal['tipolocal'].length,
                        itemBuilder: (BuildContext context, index){
                          return FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              filtroLocal(globals.jsonTipoLocal['tipolocal'][index]);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 2, right: 2),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(6))),
                              child: Center(
                                  child: Text(
                                    globals.jsonTipoLocal['tipolocal'][index]['nome'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          );
                        },
                      ) : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(left: 20),
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  filtroLocal(null);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 2, right: 2),
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6))),
                                  child: Center(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "$jsonLocaisAux ",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Icon(
                                          //FontAwesomeIcons.timesCircle,
                                          Icons.clear,
                                          color: Colors.black54,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),


                    tipoLocaisEsc == null ?
                      locaisTotal() : locaisTipo(),






                  ],
                ),


              ),
            ],
          ),
        //),
      //),
    );
  }

  ///LISTA LOCAIS
  Widget locaisTotal(){
    return
      Column(
        children: <Widget>[

          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: globals.jsonLocal['local'].length,
              itemBuilder: (BuildContext context, index){
                return Container(
                  //margin: EdgeInsets.only(left: 15, right: 5),
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
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new locaisDetalhes(globals.jsonLocal['local'][index]),));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          Divider(
            height: 100,
            color: Colors.transparent,
          ),
        ],
      );
  }


  ///TIPO LOCAL
  Widget locaisTipo(){
    return
      locaisEsc.length == 0 ? Container() : Column(
      children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: locaisEsc.length,
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
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new locaisDetalhes(locaisEsc[index]),));
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
                            child: Image(image: new CachedNetworkImageProvider("${locaisEsc[index]['imgcapa']}"),/*Image.network('${globals.jsonLocal['local'][index]['imgcapa']}',*/
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              children: <Widget>[
                                Text('${locaisEsc[index]['nome']}',
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
                                    locaisEsc[index]['nome'],
                                    locaisEsc[index]['latitude'],
                                    locaisEsc[index]['longitude']
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
        Divider(
          height: 50,
          color: Colors.transparent,
        ),
      ],
    );
  }

}
