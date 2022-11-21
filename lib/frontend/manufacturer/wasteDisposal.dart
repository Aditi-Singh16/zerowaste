import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_sms/flutter_sms.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class WasteDisposal extends StatefulWidget {
  String category;
  WasteDisposal({Key? key, required this.category}) : super(key: key);
  @override
  State<WasteDisposal> createState() => _WasteDisposalState(category);
}

class _WasteDisposalState extends State<WasteDisposal> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  HelperFunctions _helperFunctions = HelperFunctions();

  LatLng _initialcameraposition = const LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  Location _location = Location();
  double userLng = 0;
  double userLat = 0;
  double shortest = double.maxFinite;
  String nearest = "";

  //list of markers
  List<Marker> allMarkers = [];
  final Set<Polyline> _polyline = {};
  List<LatLng> latlng = [];
  String category;
  _WasteDisposalState(this.category);

  setMarkers() {
    return allMarkers;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _onCameraMove(CameraPosition position) {
    _initialcameraposition = position.target;
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    const int targetWidth = 150;
    final markerImageFile = (await DefaultCacheManager().getSingleFile(
        "https://freepngimg.com/save/66970-map-google-icons-house-maps-computer-marker/512x512"));
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Codec markerImageCodec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude as double, l.longitude as double),
              zoom: 17),
        ),
      );
      setState(() {
        userLat = l.latitude as double;
        userLng = l.longitude as double;
        allMarkers.add(Marker(
          markerId: MarkerId('Home'),
          position: LatLng(l.latitude ?? 0.0, l.longitude ?? 0.0),
          icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
          infoWindow: const InfoWindow(
            title: "Me",
          ),
        ));
      });
    });
  }

  Widget loadMap() {
    LatLng userCoords = LatLng(userLat, userLng);
    latlng.add(userCoords);
    return FutureBuilder<QuerySnapshot>(
        future: category != "All"
            ? FirebaseFirestore.instance
                .collection('disposalUnits')
                .where('category', isEqualTo: category)
                .get()
            : FirebaseFirestore.instance.collection('disposalUnits').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              double dist = calculateDistance(
                  userLat,
                  userLng,
                  snapshot.data!.docs[i]['coords'].latitude,
                  snapshot.data!.docs[i]['coords'].longitude);

              if (dist < shortest) {
                shortest = double.parse((dist).toStringAsFixed(2));
                nearest = snapshot.data!.docs[i]['name'];
                LatLng _new = LatLng(snapshot.data!.docs[i]['coords'].latitude,
                    snapshot.data!.docs[i]['coords'].longitude);
                if (latlng.length > 0) {
                  for (var i = 0; i < latlng.length; i++) {
                    latlng.removeAt(i);
                  }
                }
                latlng.add(_new);
              }
              allMarkers.add(Marker(
                markerId: MarkerId(i.toString()),
                position: LatLng(snapshot.data!.docs[i]['coords'].latitude,
                    snapshot.data!.docs[i]['coords'].longitude), // LatLng

                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                infoWindow: InfoWindow(
                    onTap: () async {
                      String username = await _helperFunctions.readNamePref();
                      String userPhone = await _helperFunctions.readPhonePref();
                      String userAddress =
                          await _helperFunctions.readAddressPref();
                      final Email email = Email(
                        body:
                            'Hi, I $username would like to connect with your recycling unit and access pickup service for my products which I wish to recycle!\n\nPhone Number: $userPhone\nAddress: $userAddress',
                        subject:
                            'Connect with ${snapshot.data!.docs[i]['name']}',
                        recipients: [snapshot.data!.docs[i]['email']],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email).then((val) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Email sent successfully, we will connect with you soon!'),
                          duration: Duration(seconds: 5),
                        ));
                      });
                    },
                    title:
                        "${snapshot.data!.docs[i]['name']}         Tap to connect",
                    snippet: "Distance = " +
                        dist.toStringAsFixed(2) +
                        "km Delivery Cost= \u{20B9}" +
                        (dist * 50).toStringAsFixed(2)),
              ));
            }
          }
          latlng.add(LatLng(userLat, userLng));
          _polyline.add(Polyline(
            polylineId: PolylineId(1.toString()),
            visible: true,
            //latlng is List<LatLng>
            points: latlng,
            color: Colors.blue,
          ));
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  onCameraMove: _onCameraMove,
                  markers: Set<Marker>.of(allMarkers),
                  polylines: _polyline,
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height / 12,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Nearest Recycling unit: \n$shortest km,$nearest"),
                      )),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: loadMap());
  }
}
