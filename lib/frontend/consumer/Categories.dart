import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/NewItems.dart';
import 'package:zerowaste/frontend/consumer/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Carousel.dart';

class UserHome extends StatefulWidget {
  UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong, Try again later!",
                    style: TextStyle(color: Colors.black, fontSize: 15)));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Color(0xFF001427),
                  title: Text("Zero Waste")),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: [
                        //---CAROUSEL
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Carousel(),
                              ),


                              //---CATEGORIES

                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Categories",
                                  style: TextStyle(

                                      letterSpacing: 2,wordSpacing: 5,
                                      color: Colors.black,
                                      fontSize: MediaQuery.of(context).size.height / 50,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),


                              //---HEIGHT OF CATEGORIES CARD
                              //---PUSH TO CATEGORIES PRODUCT LIST PAGE


                              SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                                child: ListView(
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: documents
                                      .map((doc) => InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ListPlaces(
                                                category: doc['name']),
                                          ),
                                        );
                                      },

                                      //---SPACE BETWEEN CATEGORIES CARDS


                                      child: Padding(
                                        padding: const EdgeInsets.only(left:10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(30), //border corner radius

                                          ),
                                          child: Column(
                                            children: [
                                              Container(

                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    5,
                                                decoration: BoxDecoration(

                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        doc['image'],
                                                      ),
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      2,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(5.0),
                                                    child: Text(doc['name'],
                                                        textAlign:
                                                        TextAlign.center,style: TextStyle( color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold, letterSpacing: 2,wordSpacing: 5),),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      )))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),



                              //---NEW ITEMS-----------------
                              Padding(
                                padding: const EdgeInsets.only(left:20.0, bottom: 10),
                                child: Text(
                                  "New items",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900, letterSpacing: 2,wordSpacing: 5),

                                ),
                              ),

                            ],
                          ),
                        ),



                        //---GRID VIEW IMAGES--------


                        SizedBox(
                            height: MediaQuery.of(context).size.height / 2.2,
                            child:  GridItems(),
                          ),

                        //  Divider(

                        //   height: 10,
                        //   thickness: 1,
                        //),
                      ],
                    ),
                  ),
                ));
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        });
  }
}
