import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapaPage extends StatefulWidget {

  double latitude;
  double longitude;
  String titulo;
  mapaPage(this.titulo, this.latitude, this.longitude);

  @override
  _mapaPageState createState() => _mapaPageState(titulo, latitude, longitude);
}

class _mapaPageState extends State<mapaPage> {

  double latitude;
  double longitude;
  String titulo;
  _mapaPageState(this.titulo, this.latitude, this.longitude);


  Completer<GoogleMapController> _controllerMaps = Completer();


  void initState(){
    super.initState();

  }

  MapType _currentMapType = MapType.satellite;
  void _criarMap(GoogleMapController controller) {
    _controllerMaps.complete(controller);
  }

  List<Marker> marcadorMaps = [];

  List<Marker> atualizaMarcador(double latitudeLocal, double longitudeLocal) {
    marcadorMaps.clear();
    marcadorMaps.add(Marker(
        markerId: MarkerId('Marcador'),
        draggable: false,
        onTap: () {
          print('Market Tapped');
        },
        position: LatLng(latitudeLocal, longitudeLocal)));

    return marcadorMaps;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Color(0xFF2d3447),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            Navigator.pop(context);
          }),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _criarMap,
              myLocationEnabled: true,
              mapType: _currentMapType,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      latitude,
                     longitude),
                  zoom: 16.5),
              markers: Set.from(atualizaMarcador(
                  latitude,
                  longitude)),
            ),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.map, size: 36.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
