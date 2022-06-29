import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:project_2/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/services/auth.dart';
import '../authenticate/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;

  // Display users
  Future<void> getData() async {
    userModel = await getUserModel();

    //LatLng userPosition = LatLng(userModel!.geoPoint!.latitude, userModel!.geoPoint!.longitude);
    LatLng userPosition = LatLng(2.9138371, 101.6961092);
    if (userModel != null) {
      _kGooglePlex = CameraPosition(
        target: userPosition,
        zoom: 14.5746,
      );
    }
    nearbyHospital = await googlePlace.search.getNearBySearch(
      Location(lat: userPosition.latitude,lng: userPosition.longitude),
      20000,
      type: "hospital",
      keyword: "hospital"
    );
    
    debugPrint("ANJASOL ${nearbyHospital!.status}");
    for (var e in nearbyHospital!.results!) {
      markers.add(
        Marker(
          markerId: MarkerId(e.hashCode.toString()),
          position: LatLng(e.geometry!.location!.lat!, e.geometry!.location!.lng!),
          icon: BitmapDescriptor.defaultMarkerWithHue(200)
        )
      );
      debugPrint("ANJAS ${e.businessStatus} | ${e.icon} | ${e.geometry} | ${e.name}");
    }
    
    if (mounted) setState(() {});
  }


  //logout
  Future<void> logout(BuildContext context) async {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'fcm': null});
    await AuthService().signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  GooglePlace googlePlace = GooglePlace("AIzaSyCt6BGHST7QRa5cF_aCDF9wjiVOedXzEYQ");
  NearBySearchResponse? nearbyHospital;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.purple, Colors.purple.shade200]),
          ),
        ),
        title: Text(userModel == null ? '' : 'Welcome ${userModel!.name}',
          style: TextStyle(
            fontSize: 20, color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.bold
          )
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout, color: Colors.white)
          ),
        ],
      ),
      body: userModel == null ? CircularProgressIndicator() : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
    );
  }

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('me'),
      position: LatLng(2.9138371, 101.6961092),
    )
  };

  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414
  );
  
}
