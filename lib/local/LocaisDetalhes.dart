import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guia_unifei/espaco/espaco.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'dart:async';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:guia_unifei/mapa.dart';
import 'package:url_launcher/url_launcher.dart';

class locaisDetalhes extends StatefulWidget {
  var jsonLocalAtual;

  locaisDetalhes(this.jsonLocalAtual);

  @override
  _locaisDetalhesState createState() => _locaisDetalhesState(jsonLocalAtual);
}

//var cardAspectRatio = 12.0 / 16.0;
//var widgetAspectRatio = cardAspectRatio * 1.2;
List imgsList = List();

class _locaisDetalhesState extends State<locaisDetalhes> {
  var jsonLocalAtual;
  var espacosLocal = {};
  List espacosLocalList = List();

  _locaisDetalhesState(this.jsonLocalAtual);




  @override
  void initState() {
    super.initState();

    encontraImgs();
    print('jsonLocalAtual: $jsonLocalAtual');

  }

  /// Encontra as imgs referentes ao local escolhido
  void encontraImgs() {
    imgsList.clear();

    for (int i = 0; i < globals.jsonImgs['imgslocal'].length; i++) {
      if (globals.jsonImgs['imgslocal'][i]['codlocal'] ==
          jsonLocalAtual['codigo']) {
        imgsList.add(globals.jsonImgs['imgslocal'][i]);
      }
    }
  }


  //var currentPage = imgsList.length - 1.0;

  @override
  Widget build(BuildContext context) {
    /*PageController controller = PageController(
        initialPage: imgsList.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });*/

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child:  Stack(

                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/1.8,
                    width: MediaQuery.of(context).size.width,
                    child: Image(image: new CachedNetworkImageProvider("${jsonLocalAtual['imgcapa']}"),//Image.network('${jsonLocalAtual['imgcapa']}',
                        fit: BoxFit.cover,
                      ),
                  ),

                  Container(
                    color: Colors.black.withOpacity(0.2),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.8,

                  ),

                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                        children: <Widget>[

                          Container(
                            child: Stack(
                              children: <Widget>[
                                ///BOTÃO VOLTAR
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 35,),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        }
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.map, color: Colors.white, size: 35,),
                                        onPressed: (){
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => mapaPage(jsonLocalAtual['nome'], jsonLocalAtual['latitude'], jsonLocalAtual['longitude']))
                                          );
                                        }
                                    ),
                                  ],
                                ),

                                Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 30, right: 30),

                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height/2.2,
                                      child: Center(
                                        child: Text(jsonLocalAtual['nome'],
                                          style: TextStyle(color: Colors.white,
                                            fontSize: 25,
                                            //fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),

                                    Material(
                                      elevation: 5.0,

                                      borderRadius: BorderRadius.circular(15),


                                      child: Container(
                                        width: MediaQuery.of(context).size.width/1.3,
                                        height: MediaQuery.of(context).size.width/1.3,
                                        padding: EdgeInsets.all(15),
                                        child: Swiper(
                                          itemCount: imgsList.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return Container(
                                                margin: EdgeInsets.only(left: 5, right: 5),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                    child: Hero(
                                                      tag: 'imgHero',
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => new imageView(index),));
                                                          },
                                                          child: Image(image: new CachedNetworkImageProvider("${imgsList[index]['imagem']}"),//new Image.network(imgsList[index]['imagem'],
                                                            fit: BoxFit.cover,),
                                                        ),
                                                  ),
                                                ),

                                            );
                                          },
                                          pagination: SwiperPagination(),
                                        ),
                                      ),
                                    ),

                                    FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: (){
                                        //homeList();
                                        var aux;
                                        List salasList = List();
                                        espacosLocalList.clear();

                                        print(globals.jsonEspaco['espaco'].length);
                                        for(int i=0; i<globals.jsonEspaco['espaco'].length; i++){
                                          print('Codigo Local: ${globals.jsonEspaco['espaco'][i]['codlocal']}');
                                          print('Codigo ataual: ${jsonLocalAtual['codigo']}');
                                          if(jsonLocalAtual['codigo'] == globals.jsonEspaco['espaco'][i]['codlocal']){

                                            espacosLocalList.add(globals.jsonEspaco['espaco'][i]);
                                          }

                                        }

                                        espacosLocal['espaco'] = espacosLocalList;
                                        print('espacosLocal: $espacosLocal');

                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => espacoPage(espacosLocal, false))
                                        );
                                      },
                                      
                                      child: Container(
                                        width: 150,
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(color: Color(0xFF2d3447),width: 1)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Container(
                                              child: Text('SALAS/LABS', style: TextStyle(color: Colors.white),),
                                            ),
                                            Icon(Icons.fast_forward, color: Colors.white,),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            topLeft: Radius.circular(25)
                                        ),
                                        color: Color.fromRGBO(242, 242, 242, 1),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Divider(
                                            height: 20,
                                            color: Colors.transparent,
                                          ),
                                          Text('DESCRIÇÃO', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                          Divider(
                                            height: 20,
                                            color: Colors.transparent,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15),
                                            child: Text(jsonLocalAtual['historia'],
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM DIRETOR
                                          jsonLocalAtual['diretor'] == null ? Container() :

                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                            child: Text('Diretor: ${jsonLocalAtual['diretor']}',
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM VICE-DIRETOR
                                          jsonLocalAtual['vicediretor'] == null ? Container() :

                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                            child: Text('Vice-Diretor: ${jsonLocalAtual['vicediretor']}',
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM SECRETÁRIA
                                          jsonLocalAtual['secretaria'] == null ? Container() :

                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                            child: Text('Secretária: ${jsonLocalAtual['secretaria']}',
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM EMAIL
                                          jsonLocalAtual['email'] == null ? Container() :

                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                            child: Text('Email: ${jsonLocalAtual['email']}',
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM TELEFONEDE
                                          jsonLocalAtual['telefonede'] == null ? Container() :

                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                            child: Text('Contato 1: ${jsonLocalAtual['telefonede']}',
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM TELEFONE
                                          jsonLocalAtual['telefone'] == null ? Container() :

                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.only(
                                                left: 30, right: 30, bottom: 4, top: 15),
                                            decoration: BoxDecoration(
                                              //color: Color.fromRGBO(19, 104, 136, 1),
                                              borderRadius: BorderRadius.circular(30),
                                              border:
                                              Border.all(color: Colors.green, width: 3.0),
                                            ),
                                            child: FlatButton(
                                              onPressed: () async {
                                                print('${jsonLocalAtual['telefone']}');
                                                if (await canLaunch(
                                                    'tel://+55${jsonLocalAtual['telefone']}')) {
                                                  await launch(
                                                      'tel://+55${jsonLocalAtual['telefone']}');
                                                } else {
                                                  throw 'Could not launch';
                                                }
                                              },
                                              child: Row(
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: Colors.green,
                                                  ),
                                                  Text(
                                                    'ligar',
                                                    style: TextStyle(color: Colors.green),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          /// VERIFICA SE TEM TELEFONEDE 2
                                          jsonLocalAtual['telefonede2'] == null ? Container() :

                                          Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                            child: Text('Contato 2: ${jsonLocalAtual['telefonede2']}',
                                              style: TextStyle(fontSize: 20,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),

                                          /// VERIFICA SE TEM TELEFONE 2
                                          jsonLocalAtual['telefone2'] == null ? Container() :

                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.only(
                                                left: 30, right: 30, bottom: 4, top: 15),
                                            decoration: BoxDecoration(
                                              //color: Color.fromRGBO(19, 104, 136, 1),
                                              borderRadius: BorderRadius.circular(30),
                                              border:
                                              Border.all(color: Colors.green, width: 3.0),
                                            ),
                                            child: FlatButton(
                                              onPressed: () async {
                                                print('${jsonLocalAtual['telefone2']}');
                                                if (await canLaunch(
                                                    'tel://+55${jsonLocalAtual['telefone2']}')) {
                                                  await launch(
                                                      'tel://+55${jsonLocalAtual['telefone2']}');
                                                } else {
                                                  throw 'Could not launch';
                                                }
                                              },
                                              child: Row(
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: Colors.green,
                                                  ),
                                                  Text(
                                                    'ligar',
                                                    style: TextStyle(color: Colors.green),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),






                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            )
                          ),




                        ],
                      ),
                  ),

                ],
              ),

        ),
      ),

      
    );
  }
}

class imageView extends StatelessWidget {
  int index;
  imageView(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Center(
            child: Hero(
                tag: 'imgHero',
                child: new Image.network(imgsList[index]['imagem'],fit: BoxFit.cover,)
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.only(left: 20, top: 30),
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 35,),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
