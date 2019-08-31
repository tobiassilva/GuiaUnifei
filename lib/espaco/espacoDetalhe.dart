import 'package:flutter/material.dart';

class espacoDetalhe extends StatefulWidget {
  var jsonEspacoEscolhido;

  espacoDetalhe(this.jsonEspacoEscolhido);

  @override
  _espacoDetalheState createState() => _espacoDetalheState(jsonEspacoEscolhido);
}

class _espacoDetalheState extends State<espacoDetalhe> {
  var jsonEspacoEscolhido;

  _espacoDetalheState(this.jsonEspacoEscolhido);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
        backgroundColor: Color(0xFF2d3447),
    leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
    Navigator.pop(context);
    }
    ),
    title: Text(jsonEspacoEscolhido['nome']),
    centerTitle: true,
    ),
    body: Container(),
    ),
    );
  }
}
