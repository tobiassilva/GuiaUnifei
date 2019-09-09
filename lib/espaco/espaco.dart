import 'package:flutter/material.dart';
import 'package:guia_unifei/espaco/espacoDetalhe.dart';
import 'package:cached_network_image/cached_network_image.dart';

class espacoPage extends StatefulWidget {
  var jsonEspacos;

  espacoPage(this.jsonEspacos);

  ///pode receber uma lista de espaços especificos (de um bloco, etc)

  @override
  _espacoPageState createState() => _espacoPageState(jsonEspacos);
}

class _espacoPageState extends State<espacoPage> {
  var jsonEspacos;
  _espacoPageState(this.jsonEspacos);

  List items = List<String>();
  List itemsOrigin = List<String>();
  TextEditingController editingController = TextEditingController();
  bool searchNSelec = true;

  @override
  void initState(){
    super.initState();

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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => espacoDetalhe(jsonEspacos['espaco'][i]))
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return /*MaterialApp(
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
        body: */Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Stack(
            children: <Widget>[

              ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
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
                ],
              ),


              /// SEARCH
              Container(
                margin: EdgeInsets.only(top: 10),
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
        //),
      //),
    );
  }
}
