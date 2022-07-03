import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


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
    var collection = FirebaseFirestore.instance.collection('carousel');
    collection.doc('2ZvPwOQknzv6NyQ0ScTP').snapshots().listen((docSnapshot) {
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

      return Scaffold(

        body: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            final double width = MediaQuery.of(context).size.width;
            return CarouselSlider(
              options: CarouselOptions(
             aspectRatio: 16/9,
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                height: height,
                viewportFraction: 0.6,
                enlargeCenterPage: true,
                // autoPlay: false,
              ),
              items: imgList
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
          },
        ),
      );
    }
}

