import 'package:flutter/material.dart';
import 'package:guia_unifei/local/LocaisDetalhes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class locaisList extends StatefulWidget {
  @override
  _locaisListState createState() => _locaisListState();
}

class _locaisListState extends State<locaisList> {

  HasuraConnect coneccao = HasuraConnect('https://guiaunifei.herokuapp.com/v1/graphql');

  var jsonLocal;
  void initState(){
    super.initState();
    /*var json = coneccao.subscription(docSubdescription).map((data) =>
        (data["data"]["teste"] as List)
            .map((d) => ModelData.fromJson(d)).toList()
    );*/

    var snapshot = coneccao.subscription(localSubdescription, variables: {
      // Condições ex.:
      //"id": 1
    });

    snapshot.stream.listen((data){
      print('data: $data');
      setState(() {
        jsonLocal = data['data'];
      });
    });
    print('AJSONNNN: $snapshot');


    print('jsonFinal: $jsonLocal');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15),
              //color: Colors.blue,
              child: jsonLocal == null ? Center(
                child: SpinKitCubeGrid(
                  color: Colors.blue,
                ),
              ) :
              ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: jsonLocal['local'].length,
                  itemBuilder: (BuildContext context, index){
                    return Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                            builder: (context) => new locaisDetalhes(jsonLocal['local'][index]['codigo']),));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  //color: Colors.red
                              ),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(30),
                                child: Image.network('${jsonLocal['local'][index]['imgcapa']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  children: <Widget>[
                                    Text('${jsonLocal['local'][index]['nome']}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Text('Item $index: ${jsonLocal['local'][index]['historia']}'),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

}
