import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guia_unifei/globals.dart' as globals;

class professores extends StatefulWidget {
  @override
  _professoresState createState() => _professoresState();
}

class _professoresState extends State<professores> {
  var jsonProfessor;
  bool searchNSelec = true;
  List items = List<String>();
  List itemsOrigin = List<String>();
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    jsonProfessor = globals.jsonProfessor;
    print(jsonProfessor);
    print(jsonProfessor['professor'][0]['nome']);
    print(jsonProfessor['professor'].length);

    for (int i = 0; i < jsonProfessor['professor'].length; i++) {
      items.add('${jsonProfessor['professor'][i]['nome']}');
    }
    for (int i = 0; i < jsonProfessor['professor'].length; i++) {
      itemsOrigin.add('${jsonProfessor['professor'][i]['nome']}');

      ///Não deve ser editada
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = List();
    dummySearchList.addAll(itemsOrigin);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(itemsOrigin);
      });
    }
  }

  void itemSelecionado(valor) {
    for (int i = 0; i < jsonProfessor['professor'].length; i++) {
      if (jsonProfessor['professor'][i]['nome'] == valor) {
        ///chama a Página do item selecionado correspondente
        /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => espacoDetalhe(jsonEspacos['espaco'][i]))
        );*/
        _professorDialog(jsonProfessor['professor'][i]);
      }
    }
  }

  List institutoEsc = List();
  var InstProfSelecionado;
  var jsonProfAux;

  Future<String> filtroLocal(var escolhido) {
    institutoEsc.clear();

    setState(() {
      print(escolhido);

      if (escolhido == null) {
        InstProfSelecionado = escolhido;
      } else {
        jsonProfAux = escolhido['nome'];
        InstProfSelecionado = escolhido['codigo'];
      }

      print('tipoLocaisEsc:  $InstProfSelecionado');

      if (InstProfSelecionado != null) {
        for (int i = 0; i < jsonProfessor['professor'].length; i++) {
          print(
              'globals.jsonLocal: ${jsonProfessor['professor'][i]['codlocal']}');
          if (jsonProfessor['professor'][i]['codlocal'] ==
              InstProfSelecionado) {
            institutoEsc.add(jsonProfessor['professor'][i]);
          }
        }
        print(institutoEsc);
        print(institutoEsc.length);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('PROFESSORES'),
          centerTitle: true,
        ),
        body: jsonProfessor['professor'].length == 0
            ?

        ///NÃO TEM REGISTROS DE ESPAÇO
        ///TODO: COLOCAR MENSAGEM COM REDIRECIONAMENTO PARA ENVIAREM DICAS/SOLICITAÇÃO
        Container()
            : Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Stack(
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    //padding: EdgeInsets.only(left: 15, right: 5),
                    //color: Colors.blue,
                    child: globals.jsonLocal == null
                        ? Center(
                      child: SpinKitCubeGrid(
                        color: Colors.lightBlue,
                      ),
                    )
                        : ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        /*Divider(
                                height: 210,
                              ),*/
                        Divider(
                          height: 60,
                          color: Colors.transparent,
                        ),
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(
                              left: 0,
                              right: 0,
                              top: 20,
                              bottom: 20),
                          child: InstProfSelecionado == null
                              ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: globals
                                .jsonLocal['local'].length,
                            itemBuilder:
                                (BuildContext context,
                                index) {
                              return FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  filtroLocal(globals
                                      .jsonLocal['local']
                                  [index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2),
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              6))),
                                  child: Center(
                                      child: Text(
                                        globals.jsonLocal['local']
                                        [index]['nome'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              );
                            },
                          )
                              : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                  EdgeInsets.only(left: 20),
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      filtroLocal(null);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 2, right: 2),
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius
                                                  .circular(
                                                  6))),
                                      child: Center(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "$jsonProfAux ",
                                              style: TextStyle(
                                                color: Colors
                                                    .black54,
                                              ),
                                            ),
                                            Icon(
                                              //FontAwesomeIcons.timesCircle,
                                              Icons.clear,
                                              color: Colors
                                                  .black54,
                                              size: 15,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),

                        /*Divider(
                                height: searchNSelec == false ? 70 : 5,
                                color: Colors.transparent,
                              ),*/

                        InstProfSelecionado == null
                            ? professoresTotal()
                            : professoresInstituto(),
                        Divider(
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// SEARCH
              searchBotao(),
            ],
          ),
          //),
          //),
        ),
      ),
    );
  }

  Widget professoresTotal() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: FlatButton(
            onPressed: () {
              itemSelecionado(items[index]);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 25.0,
                    // has the effect of softening the shadow
                    spreadRadius: 1.0,
                    // has the effect of extending the shadow
                    offset: Offset(
                      10.0, // horizontal, move right 10
                      10.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        FontAwesomeIcons.chalkboardTeacher,
                        size: 20,
                      )),
                  Flexible(
                    child: Text(
                      '${items[index]}',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///INSTITUTO SELECIONADO
  Widget professoresInstituto() {
    return institutoEsc.length == 0
        ? Container()
        : Column(
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: institutoEsc.length,
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                title: FlatButton(
                  onPressed: () {
                    itemSelecionado(institutoEsc[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 25.0,
                          // has the effect of softening the shadow
                          spreadRadius: 1.0,
                          // has the effect of extending the shadow
                          offset: Offset(
                            10.0, // horizontal, move right 10
                            10.0, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(
                              FontAwesomeIcons.chalkboardTeacher,
                              size: 20,
                            )),
                        Flexible(
                          child: Text(
                            '${institutoEsc[index]['nome']}',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        /*Divider(
            height: 50,
            color: Colors.transparent,
          ),*/
      ],
    );
  }

  ///SEARCH
  Widget searchBotao() {
    return Column(
      children: <Widget>[
        /* Divider(
                          height: 210,
                        ),*/
        Container(
          margin: EdgeInsets.only(top: 10),

          ///TODO: MUDAR PARA VERIFICAR SE VEIO DA HOME
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: searchNSelec == false
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.end,
            children: <Widget>[
              searchNSelec == false
                  ? Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20.0,
                        // has the effect of softening the shadow
                        spreadRadius: 2.0,
                        // has the effect of extending the shadow
                        offset: Offset(
                          10.0, // horizontal, move right 10
                          10.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: new TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Joao Carlos",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              )
                  : Container(),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    setState(() {
                      if (searchNSelec == false) {
                        searchNSelec = true;
                      } else {
                        searchNSelec = false;
                      }
                    });
                  },
                  child: searchNSelec == false
                      ? Icon(Icons.close)
                      : Icon(Icons.search),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
    print("Teste");
  }

  Future<void> _professorDialog(var jsonProfEscolhido) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MaterialApp(
            home: WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Container(
                      //margin: EdgeInsets.fromLTRB(30, 45, 30, 40),
                      width: MediaQuery.of(context).size.width/1.15,
                      height: MediaQuery.of(context).size.height/1.30,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            width: 1.0,
                            color: Colors.transparent,
                          ),
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(20.0))),
                      child: Column(
                          children: <Widget>[
                        Container(
                        height: 40,
                        decoration: new BoxDecoration(
                            color: Color(0xFF2d3447),
                            borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                IconData(57676, fontFamily: 'MaterialIcons'),
                                color: Colors.white,),
                            )
                          ],
                        ),
                      ),


                      /// NOME
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        height: 80,
                        width: MediaQuery
                            .of(context).size.width / 1.15,

                        child: Stack(
                            children: <Widget>[

                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(85, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(28),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 20.0, // has the effect of softening the shadow
                                              spreadRadius: 2.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                10.0, // horizontal, move right 10
                                                10.0, // vertical, move down 10
                                              ),
                                            )
                                          ],

                                        ),
                                        child: SelectableText("${jsonProfEscolhido['nome']}",
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //margin: EdgeInsets.only(right: 20),
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: FloatingActionButton(
                                      onPressed: null,
                                      child: Icon(FontAwesomeIcons.chalkboardTeacher, size: 35,),
                                    ),
                                  ),
                                ],
                              ),


                            ]
                        ),
                      ),


                      /// EMAIL
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        height: 80,
                        width: MediaQuery
                            .of(context).size.width / 1.15,

                        child: Stack(
                            children: <Widget>[

                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(10, 5, 85, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(28),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 20.0, // has the effect of softening the shadow
                                              spreadRadius: 2.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                10.0, // horizontal, move right 10
                                                10.0, // vertical, move down 10
                                              ),
                                            )
                                          ],

                                        ),
                                        child: SelectableText("${jsonProfEscolhido['email'] != null ? jsonProfEscolhido['email'] : 'não informado'}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    //margin: EdgeInsets.only(right: 20),
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: FloatingActionButton(
                                      onPressed: null,
                                      child: Icon(FontAwesomeIcons.at, size: 35,),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),


                            ]
                        ),
                      ),


                      /// SALA
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        height: 80,
                        width: MediaQuery
                            .of(context).size.width / 1.15,

                        child: Stack(
                            children: <Widget>[

                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(85, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(28),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 20.0, // has the effect of softening the shadow
                                              spreadRadius: 2.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                10.0, // horizontal, move right 10
                                                10.0, // vertical, move down 10
                                              ),
                                            )
                                          ],

                                        ),
                                        child: SelectableText("Sala: ${jsonProfEscolhido['sala'] != null ? jsonProfEscolhido['sala'] : 'não informado'}",
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //margin: EdgeInsets.only(right: 20),
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: FloatingActionButton(
                                      onPressed: null,
                                      child: Icon(FontAwesomeIcons.doorClosed, size: 35,),
                                      backgroundColor: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),


                            ]
                        ),
                      ),



                        /// TELEFONE
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                          height: 80,
                          width: MediaQuery
                              .of(context).size.width / 1.15,

                          child: Stack(
                              children: <Widget>[

                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[

                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 5, 85, 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(28),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 20.0, // has the effect of softening the shadow
                                                spreadRadius: 2.0, // has the effect of extending the shadow
                                                offset: Offset(
                                                  10.0, // horizontal, move right 10
                                                  10.0, // vertical, move down 10
                                                ),
                                              )
                                            ],

                                          ),
                                          child: SelectableText("${jsonProfEscolhido['telefone'] != null ? jsonProfEscolhido['telefone'] : 'não informado'}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      //margin: EdgeInsets.only(right: 20),
                                      width: 76,
                                      height: 76,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                      ),
                                      child: FloatingActionButton(
                                        onPressed: null,
                                        child: Icon(FontAwesomeIcons.mobileAlt, size: 35,),
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),


                              ]
                          ),
                        ),


                    ]),
            ),
                  ),
          ),)
          ,
          );
        });
  }
}
