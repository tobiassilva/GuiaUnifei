import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

class locaisDetalhes extends StatefulWidget {
  int codigoLocal;

  locaisDetalhes(this.codigoLocal);

  @override
  _locaisDetalhesState createState() => _locaisDetalhesState(codigoLocal);
}

class _locaisDetalhesState extends State<locaisDetalhes> {
  int codigoLocal;
  _locaisDetalhesState(this.codigoLocal);

  HasuraConnect coneccao = HasuraConnect('https://guiaunifei.herokuapp.com/v1/graphql');
  var jsonImgs;

  String imgLocalSubdescription = """
    subscription {
      imgslocal {
        codigo
        codlocal
        imagem
        nome
      }
    }
  """;

  @override
  void initState(){
    super.initState();

    var snapshot = coneccao.subscription(imgLocalSubdescription, variables: {

    });

    snapshot.stream.listen((data) {
      print('data: $data');
      setState(() {
        jsonImgs = data['data'];
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Text("TAMANHO: ${jsonImgs['imgslocal'].length}"),
            Text("valor: ${jsonImgs['imgslocal'][0]}"),
          ],
        )
      ),
    );
  }
}
