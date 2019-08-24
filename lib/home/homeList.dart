import 'package:flutter/material.dart';
import 'package:guia_unifei/local/locais.dart';

class homeList extends StatefulWidget {
  @override
  _homeListState createState() => _homeListState();
}

class _homeListState extends State<homeList> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
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
                      color: Colors.blueAccent
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
            ],
          ),
        ),
      ),
    );
  }
}
