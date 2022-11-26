import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

import '../../details.dart';

String userauthid = FirebaseAuth.instance.currentUser!.uid;
num quant = 0;

class IndividualCategoryProductList extends StatefulWidget {
  String category;
  IndividualCategoryProductList({required this.category});

  @override
  State<IndividualCategoryProductList> createState() =>
      _IndividualCategoryProductListState();
}

class _IndividualCategoryProductListState
    extends State<IndividualCategoryProductList> {
  CollectionReference newu = FirebaseFirestore.instance
      .collection('Users')
      .doc(userauthid.toString())
      .collection('Cart');

  String category = '';
  List<int> cat1 = [2, 1, 3];
  List<int> cat2 = [2, 1, 4];
  List<int> cat3 = [1, 2, 3];
  List<int> cat4 = [2, 1, 2];
  List<int> cat5 = [1, 1, 1];
  List<int> cat6 = [1, 1, 1];
  List<int> cat7 = [1, 1, 1];
  List<int> esv_ls = [];

  void setEsv(String category) {
    if (category == "Books") {
      esv_ls = cat1;
    } else if (category == "Cotton Clothes") {
      esv_ls = cat2;
    } else if (category == "Recycled Products") {
      esv_ls = cat3;
    } else if (category == "Electronics") {
      esv_ls = cat4;
    } else if (category == "Nylon Clothes") {
      esv_ls = cat5;
    } else if (category == "Silk Clothes") {
      esv_ls = cat6;
    } else {
      esv_ls = cat7;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100));

    return Column(
      children: [
        FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('products')
                .where('categories', isEqualTo: widget.category)
                .where('quantity', isGreaterThan: 0)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Scaffold(body: Loader()));
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Scaffold(
                    body: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 100, bottom: 20),
                          child: CircleAvatar(
                            radius: height / 7, // Image radius
                            backgroundImage: const NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/categories%2Fcart.gif?alt=media&token=6ef4fdc0-b651-49a6-8f23-e09a67b86d54'),
                          ),
                        ),
                        const Center(
                          child: Text(
                            "No Products in these category!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: InkWell(
                                onTap: () {
                                  // go back page
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Continue Shopping...')),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black, // background
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff001427),
                    leading: Image.asset(
                      'assets/images/logo1.png',
                      fit: BoxFit.contain,
                    ),
                    title: const Text("Orders and Returns"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          showSearch(
                              context: context, delegate: ProductSearch());
                        },
                        icon: const Icon(Icons.search),
                      )
                    ],
                    centerTitle: true,
                  ),
                  body: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height / 4,
                          child: Card(
                            margin: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 100),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.white,

                            //margin: EdgeInsets.only(left: 12.0),
                            child: InkWell(
                              onTap: () {
                                double wallet =
                                    HelperFunctions().readWalletPref();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Details(
                                          name: doc['name'],
                                          description: doc['Desc'],
                                          price: double.parse(
                                              doc['pricePerProduct']),
                                          category: doc['categories'],
                                          productid: doc['productId'],
                                          uid: userauthid,
                                          manufacturerid: doc['manufacturerId'],
                                          image: doc['image'],
                                          isPlant: doc['is_plant'],
                                          q: doc['quantity'],
                                          isResell: doc['is_resell'],
                                          wallet: wallet,
                                          weight: doc['weight'],
                                        )));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              33),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          doc['image'],
                                          fit: BoxFit.fitWidth,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            double wallet =
                                                await HelperFunctions()
                                                    .readWalletPref();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Details(
                                                          name: doc['name'],
                                                          description:
                                                              doc['Desc'],
                                                          price: double.parse(doc[
                                                              'pricePerProduct']),
                                                          category:
                                                              doc['categories'],
                                                          productid:
                                                              doc['productId'],
                                                          uid: userauthid,
                                                          manufacturerid: doc[
                                                              'manufacturerId'],
                                                          image: doc['image'],
                                                          isPlant:
                                                              doc['is_plant'],
                                                          q: doc['quantity'],
                                                          isResell:
                                                              doc['is_resell'],
                                                          wallet: wallet,
                                                          weight: doc['weight'],
                                                        )));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    30),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      150),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    doc['name'].length > 10
                                                        ? doc['name'].substring(
                                                                0, 10) +
                                                            "..."
                                                        : doc['name'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            50,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  50),
                                          child: Text(
                                            "Category: " + doc['categories'],
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    65,
                                                color: const Color(0xFF008080)),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50),
                                        Row(
                                          children: [
                                            Text(
                                              '\u{20B9}',
                                              style: TextStyle(
                                                  fontSize: height / 40),
                                            ),
                                            Text(doc['pricePerProduct'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: height / 55,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                30,
                                        right:
                                            MediaQuery.of(context).size.height /
                                                40),
                                    child: Positioned(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                30,
                                        child: Container(
                                          child: InkWell(
                                            onTap: () async {
                                              await newu.doc(doc.id).set({
                                                "name": doc['name'],
                                                "quantity": 1,
                                                "price": int.parse(
                                                    doc['pricePerProduct']),
                                                "image": doc['image'],
                                                "categories": doc['categories'],
                                                "manufacturerId":
                                                    doc['manufacturerId'],
                                                "userId": userauthid,
                                                "productId": doc['productId'],
                                              }, SetOptions(merge: true));
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  title: const Center(
                                                      child: Text(
                                                    "Added to Cart",
                                                  )),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.black,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(14),
                                                          child: const Text(
                                                            "Continue",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Icon(Icons.shopping_cart,
                                                color: const Color(0xFF008080),
                                                size: height / 40),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
              return const Loader();
            })
      ],
    );
  }
}
