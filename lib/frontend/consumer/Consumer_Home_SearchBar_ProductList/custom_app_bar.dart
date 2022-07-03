import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/Carousel.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/GridItems.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/my_Search_bar_screen.dart';


class CustomAppBar extends StatefulWidget {

  CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var size,height,width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
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
            return Container(
              padding: EdgeInsets.only(top: 80, left:25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(
                            text: "ZeroWaste",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: "\nA New Way to Save",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        ]
                      ))
                    ],
                  ),
                  Stack(
                    children: [
                      Container(

                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 0.1,
                              spreadRadius: 0.1,
                              offset: Offset(0, 1),
                            )
                          ],

                        ),
                        child: Icon(Icons.shopping_cart_outlined,  color: Colors.grey),

                      ),
                      Positioned(
                          right:10,
                          top:10,
                          child: Container(
                        width:10,
                        height:10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        });
  }
}
