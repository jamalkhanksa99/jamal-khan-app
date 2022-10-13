import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../app/models/booking_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  _MapPageState() {
    datacount = GetStorage(); // instance of getStorage class
    print(datacount.read("order_id"));

    if (datacount.read("role") != "1"){ getLocation().then((value) => p = value);

    itemRef = database
        .reference()
        .child("locations")
        .child("order" + datacount.read("order_id"));
    if( p!=null) itemRef.push().set(jsonEncode(<String, dynamic>{
      'long':p.longitude,
      'lat': p.latitude,
      'sender_id': "1",
      'message_type': 'location',
      'date': DateTime.now().hour.toString() +
          ":" +
          DateTime.now().minute.toString() +
          " - " +
          DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString()
    }));}
    itemRef.onChildAdded.listen((event) => {
          setState(() => {
            if(messages.length!=1){
                messages.insert(0, jsonDecode(event.snapshot.value)),
            current = Marker(
          markerId:
          MarkerId('current'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed),
          position: LatLng(double.parse(messages[0]['lat'].toString()),
          double.parse(messages[0]['long'].toString())),
          ),
                // markers.add(Marker(
                //   markerId:
                //       MarkerId('destination'),
                //   icon: BitmapDescriptor.defaultMarkerWithHue(
                //       BitmapDescriptor.hueRed),
                //   position: LatLng(double.parse(messages[0]['lat'].toString()),
                //       double.parse(messages[0]['long'].toString())),
                // ))
              }})
        });
  }

  Position p;
  Marker current;

  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void initializefirebase() async {
    app = await Firebase.initializeApp(
        options: FirebaseOptions(
      appId: '1:339923114931:android:43d4b565d732fbdc7109c6',
      projectId: 'jamalkhanah-d40db',
      messagingSenderId: '339923114931',
      databaseURL: "https://jamalkhanah-d40db-default-rtdb.firebaseio.com/",
    ));
  }

  static FirebaseApp app;

  final FirebaseDatabase database = FirebaseDatabase(app: app);

  DatabaseReference itemRef;

  List<dynamic> messages = [];

  var _initialCameraPosition;

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker destination= Marker(position: LatLng(34.333,35.3333));
  Directions _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  var orderId;
  var datacount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datacount = GetStorage(); // instance of getStorage class

    initializefirebase();
    print(datacount.read("order_id"));
    itemRef = database
        .reference()
        .child("locations")
        .child("order" + datacount.read("order_id"));
    orderId = datacount.read("order_id");
    double lat = datacount.read("originLat");
    double long2 = datacount.read("originLong");
    destination = Marker(position: (LatLng(lat, long2)));
    markers= {destination};
    _initialCameraPosition = CameraPosition(
      target: LatLng(lat, long2),
      zoom: 11,
    );
    _addMarker(LatLng(lat, long2), "dest");
    itemRef.push().set(jsonEncode(<String, dynamic>{
          'long': long2,
          'lat': lat,
          'sender_id': "1",
          'message_type': 'location',
          'date': DateTime.now().hour.toString() +
              ":" +
              DateTime.now().minute.toString() +
              " - " +
              DateTime.now().day.toString() +
              "/" +
              DateTime.now().month.toString() +
              "/" +
              DateTime.now().year.toString()
        }));


    // _googleMapController.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: _origin.position,
    //       zoom: 14.5,
    //       tilt: 50.0,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('تتبع الطلب'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            // markers: markers,
            zoomGesturesEnabled: true,
            // polylines: {
            //   if (_info != null)
            //     Polyline(
            //       polylineId: const PolylineId('overview_polyline'),
            //       color: Colors.red,
            //       width: 5,
            //       points: _info.polylinePoints
            //           .map((e) => LatLng(e.latitude, e.longitude))
            //           .toList(),
            //     ),
            // },
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Set<Marker> markers = {};

  void _addMarker(LatLng pos, String index) async {
    setState(() {
      Marker _origin2 = Marker(
        markerId: MarkerId('origin' + index),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
      markers.add(_origin2);
    });

    // Get directions
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin.position, destination: pos);
    setState(() => _info = directions);
    print(_info);
  }
}

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': "AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU",
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({
    @required this.bounds,
    @required this.polylinePoints,
    @required this.totalDistance,
    @required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) return null;

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
