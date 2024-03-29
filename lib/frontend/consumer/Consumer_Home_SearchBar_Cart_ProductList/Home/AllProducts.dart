import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/my_Search_bar_screen.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

String userauthid = FirebaseAuth.instance.currentUser!.uid;
num quant = 0;

class AllProducts extends StatelessWidget {
  CollectionReference newu = FirebaseFirestore.instance
      .collection('Users')
      .doc(userauthid.toString())
      .collection('Cart');
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100));
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return FutureBuilder<QuerySnapshot>(
        //get products with quantity greater than 0
        future: FirebaseFirestore.instance.collection('products').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Scaffold(
                    body: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black)))));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text('All Products'),
                backgroundColor: Color(0xFF001427),
                actions: [
                  IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: ProductSearch());
                    },
                    icon: Icon(Icons.search),
                  )
                ],
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
                          onTap: () async {
                            double wallet =
                                await HelperFunctions().readWalletPref();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Details(
                                      name: doc['name'],
                                      description: doc['Desc'],
                                      price:
                                          double.parse(doc['pricePerProduct']),
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
                                      MediaQuery.of(context).size.width / 33),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      doc['image'],
                                      fit: BoxFit.fitWidth,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              30),

                                      // child: InkWell(
                                      //   onTap: (){
                                      //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(snapshot[name],snapshot[description],snapshot[price],snapshot[categories])));
                                      //   },

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
                                                  ? doc['name']
                                                          .substring(0, 10) +
                                                      "..."
                                                  : doc['name'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          50,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
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
                                        height:
                                            MediaQuery.of(context).size.height /
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
                                          style:
                                              TextStyle(fontSize: height / 40),
                                        ),
                                        Text(doc['pricePerProduct'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: height / 55,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 30,
                                    right: MediaQuery.of(context).size.height /
                                        40),
                                child: Positioned(
                                    top:
                                        MediaQuery.of(context).size.height / 30,
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
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Center(
                                                  child: const Text(
                                                "Added to Cart",
                                              )),
                                              actions: <Widget>[
                                                Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      child: const Text(
                                                        "Continue",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
              body:
                  Center(child: CircularProgressIndicator(color: Colors.grey)));
        });
  }
}
