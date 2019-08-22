import 'package:flutter/material.dart';
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

  HasuraConnect coneccao = HasuraConnect('https://guiaunifei.herokuapp.com/v1/graphql');

  var jsonFinal;
  void initState(){
    super.initState();
    /*var json = coneccao.subscription(docSubdescription).map((data) =>
        (data["data"]["teste"] as List)
            .map((d) => ModelData.fromJson(d)).toList()
    );*/

    var snapshot = coneccao.subscription(docSubdescription, variables: {
      // Condições ex.:
      //"id": 1
    });

    snapshot.stream.listen((data){
      print('data: $data');
      jsonFinal = data;
    });
    print('AJSONNNN: $snapshot');


    print('jsonFinal: $jsonFinal');
  }

  String docSubdescription = """ 
    subscription {
      teste {
        id
        nome
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUIA UNIFEI'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: (){
            print("jsonFinal: ${jsonFinal['data']['teste'][0]['nome']}");
          },
          child: Container(
            height: 50,
            width: 50,
            color: Colors.red,
          ),
        ),
      ),
    );
  }


}

class ModelData {
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

}

