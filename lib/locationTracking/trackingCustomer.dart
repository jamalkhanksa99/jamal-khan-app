import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_services/locationTracking/pin_pill_info.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'map_pin_pill.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(34.4261350497, 35.855998989);
const LatLng DEST_LOCATION = LatLng(34.4372154762, 35.8229253175);

class MapPageCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageCustomerState();
}

class MapPageCustomerState extends State<MapPageCustomer> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  static FirebaseApp app;

  final FirebaseDatabase database = FirebaseDatabase(app: app);

  MapPageCustomerState() {
    storage = GetStorage(); // instance of getStorage class
    print(storage.read("order_id"));
    itemRef = database
        .reference()
        .child("locations")
        .child("order" + storage.read("order_id"));

    itemRef.onChildAdded.listen((event) => {
          setState(() => {
                if (messages.length != 1)
                  {
                    messages.insert(0, jsonDecode(event.snapshot.value)),
                    currentLocation = LocationData.fromMap({
                      "latitude": double.parse(messages[0]['lat'].toString()),
                      "longitude": double.parse(messages[0]['long'].toString())
                    }),
                    updatePinOnMap()
                  }
              })
        });
  }

  DatabaseReference itemRef;
  String orderId;

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  List<dynamic> messages = [];

// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  String googleAPIKey = 'AIzaSyCfTfLaBlyeMsmtYuD-OGW3wjx9YxJaYKk';

  // String googleAPIKey = 'AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU';

// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

// the user's initial location and current location
// as it moves
  LocationData currentLocation;

// a reference to the destination location
  LocationData destinationLocation;

// wrapper around the location API
  Location location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;
  var storage = GetStorage();

  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

    initializefirebase();
    print(storage.read("order_id"));
    itemRef = database
        .reference()
        .child("locations")
        .child("order" + storage.read("order_id"));
    orderId = storage.read("order_id");

    // set custom marker pins
    // setSourceAndDestinationIcons();
    // set the initial location
    destinationLocation = LocationData.fromMap({
      "latitude": storage.read("originLat"),
      "longitude": storage.read("originLong")
    });
    setInitialLocation();
  }

  void initializefirebase() async {
    app = await Firebase.initializeApp(
        options: FirebaseOptions(
      appId: Platform.isAndroid
          ? '1:339923114931:android:43d4b565d732fbdc7109c6'
          : "1:339923114931:ios:2c8c57b3f37874537109c6",
      projectId: 'jamalkhanah-d40db',
      messagingSenderId: '339923114931',
      databaseURL: "https://jamalkhanah-d40db-default-rtdb.firebaseio.com/",
    ));
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();
    print("mariam current location" + currentLocation.toString());

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": storage.read("originLat"),
      "longitude": storage.read("originLong")
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: DEST_LOCATION);

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onTap: (LatLng loc) {
                pinPillPosition = -100;
              },
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
                showPinsOnMap();
              }),
          MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin)
        ],
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);
    //
    // sourcePinInfo = PinInformation(
    //     locationName: "Start Location",
    //     location: SOURCE_LOCATION,
    //     pinPath: "assets/icon/jamal.png",
    //     labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: DEST_LOCATION,
        pinPath: "assets/icon/jamal.png",
        avatarPath: "assets/icon/jamal.png",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));

    print("markers should be" + _markers.toString());

    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    print("markers should be" + _markers.toString());
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void setPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    print(currentLocation);
    print(destinationLocation);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDBE9VNWkYw7hzr9kCKxLhy1_WUZDXutQA",
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    print(result.status.toString());
    print("888888888888");
    print(result.points);
    // print(result);
    // if (result.isNotEmpty) {
    //   result.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });

    setState(() {
      _polylines.add(Polyline(
          width: 2, // set the width of the polylines
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates));
    });
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation

    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due

    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      sourcePinInfo = PinInformation(
          locationName: "Start Location",
          location: pinPosition,
          pinPath: "assets/icon/jamal.png",
          avatarPath: "assets/icon/jamal.png",
          labelColor: Colors.blueAccent);
      sourcePinInfo.location = pinPosition;
      print("je suis ");
      print("current Location" + pinPosition.toString());
      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      print(_markers);
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
