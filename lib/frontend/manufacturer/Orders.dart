import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//
class ManuFactureOrders extends StatelessWidget {
  String manufacturerId = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Orders"),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Color(0xff265D80),
        //   centerTitle: true,
        // ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup('Orders')
                .where('manufacturerId', isEqualTo: manufacturerId)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 15),
                            child: Card(
                                color: Color(0xffD5EAEF),
                                child: ListTile(
                                  leading: Icon(CupertinoIcons.cube_box_fill,
                                      size: 30, color: Color(0xff265D80)),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Product: " +
                                            doc.data()!['ProductName'],
                                        style: TextStyle(
                                            // color: Color(0xff265D80),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Quantity: " +
                                              doc
                                                  .data()!['Quantity']
                                                  .toString(),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Amount: \u{20B9}" +
                                              doc.data()!['price'].toString() +
                                              "/product",
                                        ),
                                        SizedBox(height: 10),
                                        Text("Delivery Address: " +
                                            doc.data()!['address']),
                                        SizedBox(height: 10),
                                        Text("Phone Number: " +
                                            doc.data()!['phone_number']),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  : const SpinKitChasingDots(
                      color: Colors.blue,
                      size: 50.0,
                    );
            }));
  }
}
