import 'package:flutter/material.dart';
import 'package:guia_unifei/globals.dart' as globals;
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class locaisDetalhes extends StatefulWidget {
  var jsonLocalAtual;

  locaisDetalhes(this.jsonLocalAtual);

  @override
  _locaisDetalhesState createState() => _locaisDetalhesState(jsonLocalAtual);
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;
List imgsList = List();

class _locaisDetalhesState extends State<locaisDetalhes> {
  var jsonLocalAtual;

  _locaisDetalhesState(this.jsonLocalAtual);

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  @override
  void initState() {
    super.initState();

    encontraImgs();
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


  var currentPage = imgsList.length - 1.0;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
        initialPage: imgsList.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

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
          title: Text(jsonLocalAtual['nome']),
          centerTitle: true,
        ),
        body:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Text(jsonLocalAtual['nome'], style: TextStyle(fontSize: 25),),
              //Image.network(imgsList[1]['imagem'], fit: BoxFit.cover),
              imgsList == null ? Container() :


              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 1.5,
                    child: Stack(
                      children: <Widget>[
                        CardScrollWidget(currentPage),
                        Positioned.fill(
                          child: PageView.builder(
                              itemCount: imgsList.length,
                              controller: controller,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return Container();
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                      margin: EdgeInsets.only(top: MediaQuery
                          .of(context)
                          .size
                          .height / 1.5),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),)
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.keyboard_arrow_up, color: Colors.white,
                            size: 40,),
                          Divider(
                            height: 15,
                            color: Colors.transparent,
                          ),
                          Text(jsonLocalAtual['historia'],
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.justify,),
                          Divider(
                            height: 15,
                            color: Colors.transparent,
                          ),

                      Container(
                        width: 250,
                        height: 250,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ),
                        ),
                      ),

                        ],
                      )
                  ),


                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;

  CardScrollWidget(this.currentPage);

  var padding = 20.0;
  var verticalInset = 20.0;

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < imgsList.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding + max(
              primaryCardLeft -
                  horizontalInset * -delta * (isOnRight ? 15 : 1),
              0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(imgsList[i]['imagem'], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(imgsList[i]['nome'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: "SF-Pro-Text-Regular")),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("Read Later",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
