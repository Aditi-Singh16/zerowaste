import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/Carousel.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/GridItems.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/ShoppingCart.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/my_Search_bar_screen.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;
CollectionReference newu =
    FirebaseFirestore.instance.collection('Users').doc(uid).collection('Cart');

class CustomAppBar extends StatefulWidget {
  int amount = megatotal.toInt();

  final _formkey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime selectedDate = DateTime.now();

  //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('test').snapshots();

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
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    bool exist;

    return StreamBuilder(
        stream: newu.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Loader(),
            );
          }
          if (snapshot.hasData) {
            int cartCount = 0;
            if (snapshot.data.docs.length == 0) {
              cartCount = 0;
            } else {
              cartCount = 1;
            }

            return Container(
              padding: EdgeInsets.only(top: 80, left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "ZeroWaste",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5CAD81)),
                        ),
                        TextSpan(
                          text: "\nA New Way to Save",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ]))
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
                        child: Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  // push to cart
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShoppingCart(),
                                    ),
                                  );
                                },
                                child: Icon(Icons.shopping_cart_outlined,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        child: cartCount == 0
                            ? Container()
                            : Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF008080),
                                    shape: BoxShape.circle,
                                  ),
                                )),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return Center(
            child: Loader(),
          );
        });
  }
}
