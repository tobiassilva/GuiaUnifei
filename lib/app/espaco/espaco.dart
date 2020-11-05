import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EspacoPage extends StatefulWidget {
  var jsonEspacos;
  bool veioDaHome;

  EspacoPage(this.jsonEspacos, this.veioDaHome);

  ///pode receber uma lista de espaços especificos (de um bloco, etc)

  @override
  _EspacoPageState createState() => _EspacoPageState(jsonEspacos, veioDaHome);
}

class _EspacoPageState extends State<EspacoPage> {
  var jsonEspacos;
  bool veioDaHome;

  _EspacoPageState(this.jsonEspacos, this.veioDaHome);

  List items = List<String>();
  List itemsOrigin = List<String>();
  TextEditingController editingController = TextEditingController();
  bool searchNSelec = true;

  @override
  void initState(){
    super.initState();

    print('jsonEspacos: ${jsonEspacos['espaco'].length}');

    for(int i = 0; i<jsonEspacos['espaco'].length; i++){
      items.add('${jsonEspacos['espaco'][i]['nome']}');
    }
    for(int i = 0; i<jsonEspacos['espaco'].length; i++){
      itemsOrigin.add('${jsonEspacos['espaco'][i]['nome']}'); ///Não deve ser editada
    }


  }


  void filterSearchResults(String query) {
    List dummySearchList = List();
    dummySearchList.addAll(itemsOrigin);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
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

  void itemSelecionado(valor){
    for(int i = 0; i<jsonEspacos['espaco'].length; i++){
      if(jsonEspacos['espaco'][i]['nome'] == valor){
        ///chama a Página do item selecionado correspondente
        print(valor);
        /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => espacoDetalhe(jsonEspacos['espaco'][i]))
        );*/
        _professorDialog(jsonEspacos['espaco'][i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return veioDaHome == false ? MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: bodyEspaco(),),) : bodyEspaco();
  }


  Widget bodyEspaco(){
    return jsonEspacos['espaco'].length == 0 ?
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
              veioDaHome == false ? Container():Divider(
                height: 210,
              ),
              Divider(
                height: searchNSelec == false ? 70 : 5,
                color: Colors.transparent,
              ) ,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: FlatButton(
                      onPressed: (){
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
                              blurRadius: 25.0, // has the effect of softening the shadow
                              spreadRadius: 1.0, // has the effect of extending the shadow
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
                                child: Icon(Icons.edit_location, size: 35,)),
                            Text('${items[index]}', style: TextStyle(fontSize: 25),),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                height: 60,
                color: Colors.transparent,
              ),
            ],
          ),


          /// SEARCH
          Column(
            children: <Widget>[
              veioDaHome == false ? Container():Divider(
                height: 210,
              ),
              Container(
                margin: EdgeInsets.only(top: 10), ///TODO: MUDAR PARA VERIFICAR SE VEIO DA HOME
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: searchNSelec == false ?  MainAxisAlignment.spaceAround
                      : MainAxisAlignment.end,
                  children: <Widget>[
                    searchNSelec == false ? Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
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
                        child: new TextField(
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          controller: editingController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            //labelText: "LDC2",
                            hintText: "LDC2",
                            prefixIcon: Icon(Icons.search),
                            /*border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25.0)))*/
                          ),
                        ),
                      ),
                    ): Container(),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue,
                        onPressed: (){
                          setState(() {
                            if(searchNSelec == false){
                              searchNSelec = true;
                            } else {
                              searchNSelec = false;
                            }
                          });
                        },
                        child: searchNSelec == false ? Icon(Icons.close)
                            : Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      //),
      //),
    );
  }




  /// DIALOG DE INFOS DA SALA
  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
    print("Teste");
  }

  Future<void> _professorDialog(var jsonEspEscolhido) async {
    //var jsonEspEscolhido = value.split('.');
    var nomeEsp = jsonEspEscolhido['nome'];
    print(nomeEsp.split("."));
    var partes = nomeEsp.split(".");
    print(partes[3]);
    return showDialog(
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


                        /// PRÉDIO
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
                                          child: SelectableText("PRÉDIO:   ${partes[0]}",
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
                                        child: Icon(FontAwesomeIcons.city, size: 35,),
                                      ),
                                    ),
                                  ],
                                ),


                              ]
                          ),
                        ),


                        /// BLOCO
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
                                          child: SelectableText("BLOCO: ${partes[0]}.${partes[1]}",
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
                                        child: Icon(FontAwesomeIcons.building, size: 35,),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),


                              ]
                          ),
                        ),


                        /// ANDAR
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
                                          child: SelectableText("ANDAR: ${partes[2]}",
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
                                        child: Icon(FontAwesomeIcons.walking, size: 35,),
                                        backgroundColor: Colors.brown,
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
                                          child: SelectableText("SALA:   ${partes[3]}",
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
                                        child: Icon(FontAwesomeIcons.chalkboardTeacher, size: 35,),
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
      },
      context: context);
  }
}
