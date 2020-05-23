

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

//import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'satellite';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15.0);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {

        if ( tipoMapa == 'satellite') {
          tipoMapa = 'mapbox.mapbox-streets-v8';
        } else if (tipoMapa == 'mapbox.mapbox-streets-v8' ){
          tipoMapa = 'mapbox.mapbox-traffic-v1';
        } else if (tipoMapa == 'mapbox.mapbox-traffic-v1' ){
          tipoMapa = 'mapbox.mapbox-terrain-v2';
        } else {
          tipoMapa = 'satellite';
        }

        setState(() { });

      },
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(center: scan.getLatLng() , 
      zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
          '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken':'pk.eyJ1IjoidGV6Y2EwMyIsImEiOiJja2E2MjB0aXEwM2NtMnFwcDhia2RnNDloIn0.48hEkVBHHjYZxIk1cmSE5g',
        'id': 'mapbox.$tipoMapa',
        
      },
    );
  }

  _crearMarcadores( ScanModel scan ) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon( 
              Icons.location_on, 
              size: 70.0,
              color: Theme.of(context).primaryColor,
              ),
          )
        )
      ]
    );

  }
}
