import 'package:flutter/material.dart';
import 'package:guia_unifei/home/homeList.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hasura_connect/hasura_connect.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState(){
    super.initState();


  }

  void goHome() async {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (context) => new homeList(),));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUIA UNIFEI'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (context) => new homeList(),));
          },
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.blue,
              //border: Border.all(width: 3, color: Colors.red)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text('ENTRAR', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }


}

/*class ModelData {
  int id;
  String nome;

  ModelData(this.id, this.nome);

  ModelData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.id;
    data['user_email'] = this.nome;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "ModelData: $nome";
    //return jsonFinal;
  }

}*/

