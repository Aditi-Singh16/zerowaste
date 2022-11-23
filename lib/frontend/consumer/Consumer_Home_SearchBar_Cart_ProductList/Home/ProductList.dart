import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';

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
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Column(
      children: [
        Row(
          children: [
            const Spacing(),
            const Spacing(),
            Text('Environment Saving Values(per 100gm)'),
            ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(
                    MediaQuery.of(context).size.width * 0.1), // Image radius
                child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2F11zon_cropped.png?alt=media&token=72d9009f-c528-4fd5-a638-e933dffee8f9',
                    fit: BoxFit.cover),
              ),
            ),
            Text("Air Pollution"),
            Text(
              (esv_ls[0]).toString() + " aqi of Air",
              style: TextStyle(fontSize: width * 0.035, color: Colors.white),
            ),
            Spacer(),
            Column(
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(MediaQuery.of(context).size.width *
                        0.1), // Image radius
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2FPicsart_22-08-19_12-36-20-414.png?alt=media&token=cc0c00fb-a68a-4b69-84cd-2e60fd910215',
                        fit: BoxFit.cover),
                  ),
                ),
                Text("Tree"),
                Text((esv_ls[1]).toString().substring(0, 1) + " Tree saved",
                    style:
                        TextStyle(fontSize: width * 0.035, color: Colors.white))
              ],
            ),
            Spacer(),
            Column(
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(MediaQuery.of(context).size.width *
                        0.1), // Image radius
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2FPicsart_22-08-19_12-43-19-549.png?alt=media&token=b05f3d35-67ee-451e-8737-08e14c13c5d5',
                        fit: BoxFit.cover),
                  ),
                ),
                Text("Co2"),
                Text(((esv_ls[2]).toString()).substring(0, 3) + " ppm of Co2",
                    style:
                        TextStyle(fontSize: width * 0.035, color: Colors.white))
              ],
            ),
          ],
        ),
        FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('products')
                .where('categories', isEqualTo: widget.category)
                .where('quantity', isGreaterThan: 0)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Scaffold(
                        body: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black)))));
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Scaffold(
                    body: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 100, bottom: 20),
                          child: CircleAvatar(
                            radius: height / 7, // Image radius
                            backgroundImage: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/categories%2Fcart.gif?alt=media&token=6ef4fdc0-b651-49a6-8f23-e09a67b86d54'),
                          ),
                        ),
                        Center(
                          child: Text(
                            "No Products in these category!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: InkWell(
                                onTap: () {
                                  // go back page
                                  Navigator.of(context).pop();
                                },
                                child: Text('Continue Shopping...')),
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
                    title: Text('Products'),
                    backgroundColor: Color(0xFF001427),
                    actions: [
                      IconButton(
                        onPressed: () {
                          showSearch(
                              context: context, delegate: ProductSearch());
                        },
                        icon: Icon(Icons.search),
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
                        String name = doc['name'];
                        String prod_id = doc['productId'];
                        String manufacturerid = doc['manufacturerId'];
                        String price = doc['pricePerProduct'];
                        String description = doc['Desc'];
                        String image = doc['image'];
                        String category = doc['categories'];
                        String is_plant = doc['is_plant'];
                        int quantity = doc['quantity'];
                        bool isResell = doc['is_resell'];
                        if (name.length > 10) {
                          name = name.substring(0, 10) + "...";
                        }
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Details(
                                          name: name,
                                          description: description,
                                          price: double.parse(price),
                                          category: category,
                                          productid: prod_id,
                                          uid: userauthid,
                                          manufacturerid: manufacturerid,
                                          image: image,
                                          is_plant: is_plant,
                                          q: quantity,
                                          isResell: isResell,
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
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Details(
                                                          name: name,
                                                          description:
                                                              description,
                                                          price: double.parse(
                                                              price),
                                                          category: category,
                                                          productid: prod_id,
                                                          uid: userauthid,
                                                          manufacturerid:
                                                              manufacturerid,
                                                          image: image,
                                                          is_plant: is_plant,
                                                          q: quantity,
                                                          isResell: isResell,
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
                                                    name,
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
                                                color: Color(0xFF008080)),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                size: height / 50,
                                                color: Color(0xFF008080)),
                                            Icon(Icons.star,
                                                size: height / 50,
                                                color: Color(0xFF008080)),
                                            Icon(Icons.star,
                                                size: height / 50,
                                                color: Color(0xFF008080)),
                                            Icon(Icons.star,
                                                size: height / 50,
                                                color: Colors.black),
                                            Icon(Icons.star,
                                                size: height / 50,
                                                color: Colors.black),
                                          ],
                                        ),
                                        SizedBox(height: 20),
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
                                                  title: Center(
                                                      child: const Text(
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
                                                color: Color(0xFF008080),
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
              return Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(color: Colors.grey)));
            })
      ],
    );
  }
}
