// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:marker_icon/marker_icon.dart';

class WasteDisposal extends StatefulWidget {
  String category;
  WasteDisposal({required this.category});
  @override
  _WasteDisposalState createState() => _WasteDisposalState(category);
}

class _WasteDisposalState extends State<WasteDisposal> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
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
    final int targetWidth = 150;
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
              zoom: 15),
        ),
      );
      setState(() {
        userLat = l.latitude as double;
        userLng = l.longitude as double;
        allMarkers.add(Marker(
          markerId: MarkerId('Home'),
          position: LatLng(l.latitude ?? 0.0, l.longitude ?? 0.0),
          // icon: await MarkerIcon.downloadResizePictureCircle(
          //   'https://thumbs.dreamstime.com/b/map-pin-home-156927170.jpg',
          //   size: 50,
          // )
          // icon:
          //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
          infoWindow: InfoWindow(
            title: "Me",
          ),
        ));
      });
    });
  }

  Widget loadMap() {
    LatLng userCoords = LatLng(userLat, userLng);
    latlng.add(userCoords);
    print(userLat);
    print(userLng);
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
                print(nearest);
                LatLng _new = LatLng(snapshot.data!.docs[i]['coords'].latitude,
                    snapshot.data!.docs[i]['coords'].longitude);
                if (latlng.length > 0) {
                  for (var i = 0; i < latlng.length; i++) {
                    latlng.removeAt(i);
                  }
                }
                latlng.add(_new);
              } else {
                print("shortest=" +
                    shortest.toString() +
                    ", Dist=" +
                    dist.toString());
              }
              allMarkers.add(Marker(
                markerId: MarkerId(i.toString()),
                position: new LatLng(snapshot.data!.docs[i]['coords'].latitude,
                    snapshot.data!.docs[i]['coords'].longitude), // LatLng

                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                infoWindow: InfoWindow(
                    title: snapshot.data!.docs[i]['name'],
                    snippet: "Distance = " + dist.toStringAsFixed(2) + "km"),
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
          return Container(
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
                      height: MediaQuery.of(context).size.height / 16,
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
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(1.toString()),
    //   position: LatLng(18.975, 72.805), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'SMS Envoclean Pvt. Ltd.',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(2.toString()),
    //   position: LatLng(19.12054, 72.95129), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Antony Lara Enviro Solutions Pvt Ltd',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(3.toString()),
    //   position: LatLng(12.9699, 77.6446), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Daily Dump',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(4.toString()),
    //   position: LatLng(19.0423, 72.8491), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Dharavi Sewage site',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(5.toString()),
    //   position: LatLng(19.0898, 72.9081), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Garbage Dump',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(6.toString()),
    //   position: LatLng(19.0853, 72.9041), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Trash collection site',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add second marker
    //   markerId: MarkerId(7.toString()),
    //   position: LatLng(19.0863, 72.9121), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Dump',
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueGreen), //Icon for Marker
    // ));
    return Scaffold(body: loadMap());
  }
}
