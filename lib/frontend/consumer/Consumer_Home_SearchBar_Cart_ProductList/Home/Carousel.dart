import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

CollectionReference coll= FirebaseFirestore.instance.collection('carousel');
final List<String> imgList = [
  '',
  '',
  '',
];


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Carousel());

}

class Carousel extends StatefulWidget{

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  Future fun () async {

    coll.doc('2ZvPwOQknzv6NyQ0ScTP').snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        setState(() {


          imgList[0]=data['gallery'][0];
          imgList[1]=data['gallery'][1];
          imgList[2]=data['gallery'][2];

        });
        // You can then retrieve the value from the Map like this:

      }
    });
  }
  @override
  void initState() {
    super.initState();
    fun();

  }

  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100));
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final List<String> imgL= [
      '',
      '',
      '',
    ];

      // retrun a futurebuilder to load the images from the firebase storage
      return FutureBuilder(
        future:  FirebaseFirestore.instance.collection('carousel').get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {


          imgL[0]=snapshot.data.docs[0].data()['gallery'][0];
          imgL[1]=snapshot.data.docs[0].data()['gallery'][1];
          imgL[2]=snapshot.data.docs[0].data()['gallery'][2];
          if (snapshot.hasError) {
            // for loop through document length to get the images
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black)));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 1.9,
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  height: height,
                  viewportFraction: 0.7,
                  enlargeCenterPage: true,
                  // autoPlay: false,
                ),
                items:  imgL
                    .map((item) => Container(
                  child: Center(
                      child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        height: height,
                      )),
                ))
                    .toList(),
              );
            }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
          }

      );

    }
}

