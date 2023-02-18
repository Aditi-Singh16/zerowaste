import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/ShoppingCart.dart';
import 'package:zerowaste/frontend/manufacturer/inputDisposalCategory.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;

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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Cart')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
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
              padding: const EdgeInsets.only(top: 80, left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RichText(
                          text: const TextSpan(children: [
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 0.1,
                              spreadRadius: 0.1,
                              offset: const Offset(0, 1),
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
                                child: const Icon(Icons.shopping_cart_outlined,
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
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF008080),
                                    shape: BoxShape.circle,
                                  ),
                                )),
                      ),
                    ],
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputCategory(),
                        ),
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.map,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.height / 24,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Loader(),
          );
        });
  }
}
