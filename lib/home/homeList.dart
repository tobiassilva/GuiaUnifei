import 'package:flutter/material.dart';
import 'package:guia_unifei/espaco/espaco.dart';
import 'package:guia_unifei/local/locais.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class homeList extends StatefulWidget {
  @override
  _homeListState createState() => _homeListState();
}

class _homeListState extends State<homeList> {

  TabController _tabController;

  @override
  void initState(){
    super.initState();
    //_tabController = new TabController(length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                //Navigator.pop(context);
              }
          ),
          bottom: TabBar(    // TabBar
            //controller: _tabController,
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
          ),
        ),
        body:TabBarView(
                controller: _tabController,
                children: <Widget>[

                  locaisList(),
                  espacoPage(globals.jsonEspaco, true),


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
      ),
    );
  }
}
