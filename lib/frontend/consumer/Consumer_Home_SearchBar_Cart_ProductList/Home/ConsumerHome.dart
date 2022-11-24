import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
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
              child: Loader(),
            );
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
                            CategoryList('New Arrivals'),
                            GridItems(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          }
          return Center(
            child: Loader(),
          );
        });
  }
}
