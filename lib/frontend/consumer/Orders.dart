// ignore_for_file: avoid_unnecessary_containers, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zerowaste/frontend/consumer/return.dart';
import 'package:zerowaste/frontend/consumer/consumerNavbar.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class YourOrders extends StatefulWidget {
  const YourOrders({Key? key}) : super(key: key);

  @override
  State<YourOrders> createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('Orders')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Text('something went wrong');
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Column(
                      children: <Widget>[
                        const Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('No connection'),
                        )
                      ],
                    );
                  case ConnectionState.waiting:
                    return const SpinKitChasingDots(
                      color: Colors.blue,
                      size: 50.0,
                    );

                  case ConnectionState.active:
                    if (snapshot.data!.docs.isEmpty) {
                      return Scaffold(
                        body: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 100, bottom: 20),
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.height /
                                    7, // Image radius
                                backgroundImage: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/categories%2Fcart.gif?alt=media&token=6ef4fdc0-b651-49a6-8f23-e09a67b86d54'),
                              ),
                            ),
                            Center(
                              child: Text(
                                "No orders yet!",
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConsumerNavbar()));
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
                    //print(snapshot.data!.docs.length);
                    else
                      return Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                            leading: Image.asset(
                              'assets/images/logo1.png',
                              fit: BoxFit.contain,
                            ),
                            title: Text("My Orders")),
                        body: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              print(doc.data());
                              return Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                                child: Card(
                                  margin: EdgeInsets.all(
                                      MediaQuery.of(context).size.height / 80),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.network(doc['image'],
                                              fit: BoxFit.fitHeight,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3
                                              //color: Colors.red,
                                              ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 20),
                                              Text(
                                                doc['ProductName'],
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          50,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                doc['Date'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Quantity: " +
                                                        doc['Quantity']
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "\u{20B9}" +
                                                        doc['Amount']
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  doc['is_resell']
                                                      ? ElevatedButton(
                                                          onPressed: () async {
                                                            String docId =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'products')
                                                                    .doc()
                                                                    .id;

                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc(docId)
                                                                .set(
                                                                    {
                                                                  'name': doc[
                                                                      'ProductName'],
                                                                  'Desc': doc[
                                                                      'Desc'],
                                                                  'image': doc[
                                                                      'image'],
                                                                  'categories':
                                                                      doc['category'],
                                                                  'quantity': doc[
                                                                      'Quantity'],
                                                                  'pricePerProduct':
                                                                      doc['price']
                                                                          .toString(),
                                                                  'timestamp':
                                                                      DateTime
                                                                          .now(),
                                                                  'is_plant':
                                                                      "true",
                                                                  'weight': doc[
                                                                      'weight'],
                                                                  "is_resell":
                                                                      true,
                                                                  "productId":
                                                                      docId,
                                                                  "manufacturerId":
                                                                      await HelperFunctions()
                                                                          .readUserIdPref()
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .doc(uid)
                                                                .collection(
                                                                    'Orders')
                                                                .doc(doc.id)
                                                                .set(
                                                                    {
                                                                  'is_resell':
                                                                      false
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true)).then(
                                                                    (value) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text('Initiated Resell')));
                                                            });
                                                          },
                                                          child: Text(
                                                            "Resell",
                                                          ))
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    content: Text(
                                                                        "Can be reselled once only"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red));
                                                          },
                                                          child: Text("Resell"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .grey),
                                                        ),
                                                  SizedBox(width: 15),
                                                  !doc['is_return']
                                                      ? ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => ReturnOrder(
                                                                    productName: doc[
                                                                        'ProductName'],
                                                                    manufacturerId:
                                                                        doc[
                                                                            'manufacturerId'],
                                                                    price: doc[
                                                                            'price']
                                                                        .toDouble(),
                                                                    address: doc[
                                                                        'address'],
                                                                    orderedQuantity: doc[
                                                                            'Quantity']
                                                                        .toInt(),
                                                                    orderId: doc[
                                                                        'orderId'],
                                                                    image: doc[
                                                                        'image'])));
                                                          },
                                                          child: Text(
                                                            "Return",
                                                          ))
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    content: Text(
                                                                        "Can only be returned once"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red));
                                                          },
                                                          child: Text("Return"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .grey),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                  case ConnectionState.done:
                    return Container();
                }
              }
            }));
  }
}
