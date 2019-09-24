import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guia_unifei/espaco/espaco.dart';
import 'package:guia_unifei/local/locais.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class homeList extends StatefulWidget {
  @override
  _homeListState createState() => _homeListState();
}

class _homeListState extends State<homeList> {

  TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = new TabController(length: 2, vsync: ScaffoldState());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        /*appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                //Navigator.pop(context);
              }
          ),
          /*bottom: TabBar(    // TabBar
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 2,
              //controller: _tabController,
            tabs: <Widget>[
              Tab(
                child: new Text(
                  "BLOCOS",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Gibson",
                      fontStyle: FontStyle.normal,
                      fontSize: 15),
                ),

              ),
              Tab(
                child: new Text("SALAS / LABS",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Gibson",
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0)),
              ),
            ],
          ),*/
        ),*/
        body: Stack(
          ///AAAAAAAAAAAAAAPPPPPPPPPPPPPAAAAGGGGGGGGGGAAAAAAAAAAA AAAAAAAQQQQQUUUUUUUIIIIIIIIIIIIIIIII
          children: <Widget>[


            Container(
              //padding: EdgeInsets.only(top: 250),
              //height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[

                  locaisList(),
                  espacoPage(globals.jsonEspaco, true),


                ],
              ),
            ),


                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider("${globals.jsonLocal['local'][0]['imgcapa']}"), ///TODO: DEFINIR UMA IMAGEM ESTÁTICA
                        fit: BoxFit.fill,
                        //fit: BoxFit.fill
                      ),
                    ),

                  ),
                ),



                Container(
                  padding: EdgeInsets.only(top: 150),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.3,
                            decoration: new BoxDecoration(
                              color: Color.fromRGBO(45, 52, 71, 0.95),
                              //borderRadius: BorderRadius.circular(30)
                            ),
                            height: 40,
                            //width: MediaQuery.of(context).size.width,
                            child: TabBar(    // TabBar
                              controller: _tabController,
                              indicatorColor: Colors.white,
                              //indicatorWeight: 2,
                              //controller: _tabController,
                              tabs: <Widget>[
                                Tab(
                                  child: new Text(
                                    "BLOCOS",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Gibson",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15),
                                  ),

                                ),
                                Tab(
                                  child: new Text("SALAS/LABS",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Gibson",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),




          ],
        ),
         /*Container(
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: <Widget>[

              /// LOCAIS
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

              ///SALAS E ESPAÇOS
              FlatButton(
                onPressed: (){
                 Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context)=> espacoPage(globals.jsonEspaco))
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
                        child: Text('Encontre por Salas', style: TextStyle(color: Colors.white, fontSize: 22),),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),*/
      ),
    );
  }
}
