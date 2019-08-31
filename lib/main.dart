import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guia_unifei/home/homeList.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hasura_connect/hasura_connect.dart';
import 'globals.dart' as globals;


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

  HasuraConnect conexao = HasuraConnect('https://guiaunifei.herokuapp.com/v1/graphql');

  bool leituraBanco = false;

  @override
  void initState() {
    super.initState();
    this.getLocais();
    this.getImgsLocais();
    this.getTipoLocais();
    this.getEspacos();
    this.getTipoEspaco();

    print('aaaaaaaaaaaaa');


  }

  ///RECEBE O JSON DOS LOCAIS
  Future<void> getLocais() async {
    var snapshot = conexao.subscription(localSubdescription, variables: {
    });

    snapshot.stream.listen((data){
      print('data: $data');
      setState(() {
        globals.jsonLocal = data['data'];
      });
    });
  }

  ///RECEBE O JSON DAS IMAGENS DO LOCAL
  Future<void> getImgsLocais() async {

    var snapshot1 = conexao.subscription(imgLocalSubdescription, variables: {

    });

    snapshot1.stream.listen((data) {
      print('data: $data');
      setState(() {
        globals.jsonImgs = data['data'];
      });
    });

  }

  ///RECEBE O JSON DOS TIPOS DE LOCAIS
  Future<void> getTipoLocais() async {

    var snapshot1 = conexao.subscription(tipoLocalSubdescription, variables: {

    });

    snapshot1.stream.listen((data) {
      print('data: $data');
      setState(() {
        globals.jsonTipoLocal = data['data'];
        print('jsonTipoLocal: ${globals.jsonTipoLocal}');
        print(globals.jsonTipoLocal['tipolocal'].length);
        leituraBanco = true;
      });
    });

  }

  ///RECEBE O JSON DOS ESPAÇOS
  Future<void> getEspacos() async {

    var snapshot1 = conexao.subscription(espacoSubdescription, variables: {

    });

    snapshot1.stream.listen((data) {
      print('data: $data');
      setState(() {
        globals.jsonEspaco = data['data'];
        print('jsonEspaco: ${globals.jsonEspaco}');
        print(globals.jsonEspaco['espaco'].length);
      });
    });

  }

  ///RECEBE O JSON DOS TIPOS DE ESPACOS
  Future<void> getTipoEspaco() async {

    var snapshot1 = conexao.subscription(tipoEspacoSubdescription, variables: {

    });

    snapshot1.stream.listen((data) {
      print('data: $data');
      setState(() {
        globals.jsonTipoEspaco = data['data'];
        print('jsonTipoEspaco: ${globals.jsonTipoEspaco}');
        print(globals.jsonTipoEspaco['tipoespaco'].length);
        leituraBanco = true;
      });
    });

  }

  String localSubdescription = """ 
    subscription {
      local {
        anoconstrucao
        codigo
        codtlocal
        imgcapa
        nome
        historia
        latitude
        longitude
      }
    }
  """;

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

  String tipoLocalSubdescription = """
      subscription {
        tipolocal {
          codigo
          nome
        }
      }
    """;

  String espacoSubdescription = """
      subscription {
        espaco {
          codigo
          codlocal
          codtespaco
          nome
          andar
        }
      }
    """;

  String tipoEspacoSubdescription = """
      subscription {
        tipoespaco {
          codigo
          tipo
        }
      }
    """;

  void goHome() async {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (context) => new homeList(),));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUIA UNIFEI'),
        centerTitle: true,
      ),
      body: leituraBanco == false ? Center(
        child: SpinKitCubeGrid(
          color: Colors.lightBlue,
        ),
      ) : Center(
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

