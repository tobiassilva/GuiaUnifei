import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guia_unifei/app/espaco/espaco.dart';
import 'package:guia_unifei/app/local/locais.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:guia_unifei/app/professores/professores.dart';
import 'package:guia_unifei/app/qrCode/qrCode.dart';
import 'package:guia_unifei/tabs/menu.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        //drawer: drawer(),
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),

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
                  EspacoPage(globals.jsonEspaco, true),
                  //qrCode()


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



                Column(
                  children: <Widget>[
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: (){

                            }
                        ),
                      ],
                    ),*/
                    Container(
                      padding: EdgeInsets.only(top: 150),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.1,
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
                                              fontSize: 15.0),
                                      textAlign: TextAlign.center,),
                                    ),
                                    /*Tab(
                                      child: new Text("QR-CODE",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Gibson",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0)),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
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
        floatingActionButton: SpeedDial(
          marginRight: 25,
          marginBottom: 5,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 23.0, color: Colors.white),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',

          backgroundColor: Color(0xFF2d3447),
          foregroundColor: Colors.black,

          shape: CircleBorder(),
          elevation: 50.0,
          children: [
            SpeedDialChild(
                child: Icon(FontAwesomeIcons.chalkboardTeacher),
                backgroundColor: Colors.red,
                label: 'Professores',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => professores()));
                }
            ),
            SpeedDialChild(
              child: Icon(FontAwesomeIcons.qrcode),
              backgroundColor: Colors.blue,
              label: 'QRcode',
              labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => qrCode()));
                }
            ),
            SpeedDialChild(
              child: Icon(FontAwesomeIcons.home),
              backgroundColor: Colors.green,
              label: 'Home',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('THIRD CHILD'),
            ),
          ],
        ),

        /*FloatingActionButton(
          onPressed: () => setState(() {
          }),
          tooltip: 'Increment Counter',
          child: Icon(Icons.add),
        ),*/
          //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        /*bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0,),
        ),*/
      ),
    );
  }
}
