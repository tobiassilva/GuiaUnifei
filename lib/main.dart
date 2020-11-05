import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guia_unifei/app/home/homeList.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hasura_connect/hasura_connect.dart';
import 'globals.dart' as globals;
import 'package:connectivity/connectivity.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';


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

final LocalStorage storage = new LocalStorage("json");

class _MyHomePageState extends State<MyHomePage> {

  HasuraConnect conexao = HasuraConnect('https://guiaunifei.herokuapp.com/v1/graphql');

  bool leituraBanco = false;
  bool primeiroAcesso = false;

  Future conectaHasura() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print('connectivityResult: $connectivityResult');
    if(connectivityResult != ConnectivityResult.none){
      conexao = HasuraConnect('https://guiaunifei.herokuapp.com/v1/graphql');
    }
  }

  @override
  void initState() {
    super.initState();
    //this.conectaHasura();
    this.getLocais();
    this.getImgsLocais();
    this.getTipoLocais();
    this.getEspacos();
    this.getTipoEspaco();
    this.getProfessor();

    print('aaaaaaaaaaaaa');

    /*if(primeiroAcesso == true){
      alertInfoErro(context, 'Primeiro Acesso?\nConecte-se a internet para carregar os dados. Depois, pode entrar sem internet :)');
    }*/

  }

  //Encontre o caminho local correto
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  ///Crie uma referência para o local do arquivo
  ///
  ///
  ///LOCAL
  Future<File> get _localFileLocal async {
    final path = await _localPath;
    return File('$path/local.txt');
  }

  ///LOCAL IMAGENS
  Future<File> get _localFileLocalImgs async {
    final path = await _localPath;
    return File('$path/localImgs.txt');
  }

  ///TIPO LOCAL
  Future<File> get _localFileTipoLocal async {
    final path = await _localPath;
    return File('$path/tipoLocal.txt');
  }

  ///ESPACO
  Future<File> get _localFileEspaco async {
    final path = await _localPath;
    return File('$path/espaco.txt');
  }

  ///TIPO ESPACO
  Future<File> get _localFileTipoEspaco async {
    final path = await _localPath;
    return File('$path/tipoEspaco.txt');
  }

  ///PROFESSOR
  Future<File> get _localFileProfessor async {
    final path = await _localPath;
    return File('$path/professor.txt');
  }

  //Verifica se está conectado na internet
  Future<bool> verificaConeccao() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.none){
      return true;
    } else {
      return false;
    }
  }

  ///RECEBE O JSON DOS LOCAIS
  Future<void> getLocais() async {
    var coneccao = await verificaConeccao();
    print('SSSSSSSSSSSSSSSSSSSSS');

    if(coneccao == false){ //se estiver conectado
      var snapshot = conexao.subscription(localSubdescription, variables: {
      });

      snapshot.stream.listen((data) async {
        print('data: $data');
        setState(() {
          globals.jsonLocal = data['data'];
          leituraBanco = true;

        });

        ///GRAVANDO DADOS EM UM ARQUIVO
        final file = await _localFileLocal;
        String aux = jsonEncode(data['data']);
        // GRAVA NO ARQUIVO
        file.writeAsString('$aux');
        print('aux: $aux');

        // Salvando img em cached
        for(int i = 0; i < data['data']['local'].length; i++){
          imagemCached("${data['data']['local'][i]['imgcapa']}");
        }

      });
    } else {
      try {
        final file = await _localFileLocal;

        // Read the file
        String contents = await file.readAsString();

        print('contents: $contents');
        globals.jsonLocal = jsonDecode(contents);

        print('globals.jsonLocal: ${globals.jsonLocal['local'][0]}');
        setState(() {
          leituraBanco = true; //tira o temporizador e abre a HOME
        });
      } catch (e) { //se nao tem internet e nao existe o arquivo
        setState(() { //tira o temporizador e mostra alert de solicitação de internet
          leituraBanco = true;
          primeiroAcesso = true;
        });
      }
    }


  }

  ///RECEBE O JSON DAS IMAGENS DO LOCAL
  Future<void> getImgsLocais() async {
    var coneccao = await verificaConeccao();
    print('SSSSSSSSSSSSSSSSSSSSS');

    if(coneccao == false){ //se estiver conectado
      var snapshot1 = conexao.subscription(imgLocalSubdescription, variables: {

      });

      snapshot1.stream.listen((data) async {
        print('data: $data');
        setState(() {
          globals.jsonImgs = data['data'];
          leituraBanco = true;
        });

        ///GRAVANDO DADOS EM UM ARQUIVO
        final file = await _localFileLocalImgs;
        String aux = jsonEncode(data['data']);
        // GRAVA NO ARQUIVO
        file.writeAsString('$aux');
        print('aux: $aux');

        //Salva Imagens em cached
        for(int i = 0; i < data['data']['imgslocal'].length; i++){
          imagemCached("${data['data']['imgslocal'][i]['imagem']}");
        }
      });
    } else {
      try {
        final file = await _localFileLocalImgs;

        // Read the file
        String contents = await file.readAsString();

        print('contents: $contents');
        globals.jsonImgs = jsonDecode(contents);

        print('globals.jsonImgs: ${globals.jsonImgs['imgslocal'][0]}');
        setState(() {
          leituraBanco = true; //tira o temporizador e abre a HOME
        });
      } catch (e) { //se nao tem internet e nao existe o arquivo
        setState(() { //tira o temporizador e mostra alert de solicitação de internet
          leituraBanco = true;
          primeiroAcesso = true;
        });
        // If encountering an error, return 0
        return 0;
      }
    }

  }

  ///RECEBE O JSON DOS TIPOS DE LOCAIS
  Future<void> getTipoLocais() async {
    var coneccao = await verificaConeccao();
    print('SSSSSSSSSSSSSSSSSSSSS');

    if(coneccao == false){ //se estiver conectado
      var snapshot1 = conexao.subscription(tipoLocalSubdescription, variables: {

      });

      snapshot1.stream.listen((data) async {
        print('data: $data');
        setState(() {
          globals.jsonTipoLocal = data['data'];
          leituraBanco = true;
        });

        ///GRAVANDO DADOS EM UM ARQUIVO
        final file = await _localFileTipoLocal;
        String aux = jsonEncode(data['data']);
        // GRAVA NO ARQUIVO
        file.writeAsString('$aux');
        print('aux: $aux');

      });
    } else {
      try {
        final file = await _localFileTipoLocal;

        // Read the file
        String contents = await file.readAsString();

        print('contents: $contents');
        globals.jsonTipoLocal = jsonDecode(contents);

        print('globals.jsonTipoLocal: ${globals.jsonTipoLocal}');
        setState(() {
          leituraBanco = true; //tira o temporizador e abre a HOME
        });
      } catch (e) { //se nao tem internet e nao existe o arquivo
        setState(() { //tira o temporizador e mostra alert de solicitação de internet
          leituraBanco = true;
          primeiroAcesso = true;
        });
      }
    }

  }

  ///RECEBE O JSON DOS ESPAÇOS
  Future<void> getEspacos() async {

    var coneccao = await verificaConeccao();
    print('SSSSSSSSSSSSSSSSSSSSS');

    if(coneccao == false){ //se estiver conectado

      var snapshot1 = conexao.subscription(espacoSubdescription, variables: {

      });

      snapshot1.stream.listen((data) async {
        print('data: $data');
        setState(() {
          globals.jsonEspaco = data['data'];
          leituraBanco = true;
        });

        ///GRAVANDO DADOS EM UM ARQUIVO
        final file = await _localFileEspaco;
        String aux = jsonEncode(data['data']);
        // GRAVA NO ARQUIVO
        file.writeAsString('$aux');
        print('aux: $aux');
      });
    } else {
      try {
        final file = await _localFileEspaco;

        // Read the file
        String contents = await file.readAsString();

        print('contents: $contents');
        globals.jsonEspaco = jsonDecode(contents);

        print('globals.jsonEspaco: ${globals.jsonEspaco}');
        setState(() {
          leituraBanco = true; //tira o temporizador e abre a HOME
        });
      } catch (e) { //se nao tem internet e nao existe o arquivo
        setState(() { //tira o temporizador e mostra alert de solicitação de internet
          leituraBanco = true;
          primeiroAcesso = true;
        });
      }
    }

  }

  ///RECEBE O JSON DOS TIPOS DE ESPACOS
  Future<void> getTipoEspaco() async {
    var coneccao = await verificaConeccao();

    if(coneccao == false){ //se estiver conectado
      var snapshot1 = conexao.subscription(tipoEspacoSubdescription, variables: {
      });

      snapshot1.stream.listen((data) async {
        print('data: $data');
        setState(() {
          globals.jsonTipoEspaco = data['data'];
          leituraBanco = true;
        });

        ///GRAVANDO DADOS EM UM ARQUIVO
        final file = await _localFileTipoEspaco;
        String aux = jsonEncode(data['data']);
        // GRAVA NO ARQUIVO
        file.writeAsString('$aux');
        print('aux: $aux');
      });
    } else {
      try {
        final file = await _localFileTipoEspaco;

        // Read the file
        String contents = await file.readAsString();

        print('contents: $contents');
        globals.jsonTipoEspaco = jsonDecode(contents);

        print('globals.jsonTipoEspaco: ${globals.jsonTipoEspaco}');
        setState(() {
          leituraBanco = true; //tira o temporizador e abre a HOME
        });
      } catch (e) { //se nao tem internet e nao existe o arquivo
        setState(() { //tira o temporizador e mostra alert de solicitação de internet
          leituraBanco = true;
          primeiroAcesso = true;
        });
      }
    }

  }

  ///RECEBE O JSON DOS PROFESSORES
  Future<void> getProfessor() async {
    var coneccao = await verificaConeccao();
    print('SSSSSSSSSSSSSSSSSSSSS');

    if(coneccao == false){ //se estiver conectado

      var snapshot1 = conexao.subscription(professorSubdescription, variables: {

      });

      snapshot1.stream.listen((data) async {
        print('data: $data');
        setState(() {
          globals.jsonProfessor = data['data'];
          leituraBanco = true;
        });

        ///GRAVANDO DADOS EM UM ARQUIVO
        final file = await _localFileProfessor;
        String aux = jsonEncode(data['data']);
        // GRAVA NO ARQUIVO
        file.writeAsString('$aux');
        print('aux: $aux');
      });
    } else {
      try {
        final file = await _localFileProfessor;

        // Read the file
        String contents = await file.readAsString();

        print('contents: $contents');
        globals.jsonProfessor = jsonDecode(contents);

        print('globals.jsonProfessor: ${globals.jsonProfessor}');
        setState(() {
          leituraBanco = true; //tira o temporizador e abre a HOME
        });
      } catch (e) { //se nao tem internet e nao existe o arquivo
        setState(() { //tira o temporizador e mostra alert de solicitação de internet
          leituraBanco = true;
          primeiroAcesso = true;
        });
      }
    }

  }


  void imagemCached(var urlImage){
    CachedNetworkImage(
      imageUrl: "$urlImage",
      placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
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
        diretor
        vicediretor
        secretaria
        email
        telefone
        telefonede
        telefone2
        telefonede2
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


  String professorSubdescription = """ 
    subscription {
      professor {
        codigo
        codlocal
        email
        nome
        sala
        telefone
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
      ) :
      primeiroAcesso == true ? alertInfoErro(context,
          'Primeiro Acesso?\n\nConecte-se a internet e clique em "RECARREGAR" para acessar os dados. \nDepois, pode entrar mesmo sem internet :)'
    /*'Olá, você precisa se conectar na internet para acessar todos os dados!'*/
      ) :
    Center(
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


Widget alertInfoErro(BuildContext context, msgAlerta) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 410,
          width: 240,
          /*margin: EdgeInsets.fromLTRB(30, 65, 30, 60),*/
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: new BoxDecoration(
              color: Color(0xFF2d3447),
              border: new Border.all(
                width: 1.0,
                color: Colors.transparent,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.signal_wifi_off,
                size: 80,
                color: Colors.red,
              ),
              Text(
                msgAlerta,
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => new MyApp(),));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'RECARREGAR',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
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

