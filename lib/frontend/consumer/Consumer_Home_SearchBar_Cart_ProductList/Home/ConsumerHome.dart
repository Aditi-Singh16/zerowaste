import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/Carousel.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/GridItems.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/View_all_text.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/custom_app_bar.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/my_Search_bar_screen.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search_input.dart';

CollectionReference u = FirebaseFirestore.instance.collection('categories');

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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100));
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return StreamBuilder(
        stream: u.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)));
          }
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return Scaffold(
                backgroundColor: Colors.grey[100],
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CustomAppBar(),
                        ),

                        //---CAROUSEL
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          //   SizedBox(
                          //     width: width,
                          //     height: height / 4,
                          //     child: Carousel(),
                          //   ),
                          //   SearchInput(),
                          //   //---CATEGORIES
                          //   CategoryList('Category'),
                          //   //---HEIGHT OF CATEGORIES CARD
                          //   SizedBox(
                          //     height: height / 4.5,
                          //     child: ListView(
                          //       physics: ScrollPhysics(),
                          //       scrollDirection: Axis.horizontal,
                          //       shrinkWrap: true,
                          //       children: documents
                          //           .map((doc) => InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         IndividualCategoryProductList(
                          //                             category: doc['name']),
                          //                   ),
                          //                 );
                          //               },

                          //               //---SPACE BETWEEN CATEGORIES CARDS
                          //               child: Padding(
                          //                 padding:
                          //                     const EdgeInsets.only(left: 10.0),
                          //                 child: Container(
                          //                   decoration: BoxDecoration(
                          //                     color: Colors.white,
                          //                     borderRadius:
                          //                         BorderRadius.circular(
                          //                             30), //border corner radius
                          //                   ),
                          //                   child: Column(
                          //                     children: [
                          //                       Stack(
                          //                         children: [
                          //                           Container(
                          //                             margin: EdgeInsets.all(8),
                          //                             height: height / 6,
                          //                             width: width / 2.3,
                          //                             decoration: BoxDecoration(
                          //                               borderRadius:
                          //                                   BorderRadius
                          //                                       .circular(15),
                          //                               image: DecorationImage(
                          //                                 image: NetworkImage(
                          //                                     doc['image']),
                          //                                 fit: BoxFit.fitHeight,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           // Positioned(
                          //                           //     right:20,
                          //                           //     top:15,
                          //                           //     child: Container(
                          //                           //
                          //                           //
                          //                           //
                          //                           //         child: Icon(Icons.favorite, color: Colors.red,
                          //                           //         size:15),
                          //                           //     )),
                          //                         ],
                          //                       ),
                          //                       Text(doc['name'],
                          //                           style: TextStyle(
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             height: 1.5,
                          //                           )),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               )))
                          //           .toList(),
                          //     ),
                          //   ),
                            //---NEW ITEMS-----------------
                            CategoryList('New Arrivals'),
                            GridItems(),
                          ],
                        ),

                        //---GRID VIEW IMAGES--------

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
