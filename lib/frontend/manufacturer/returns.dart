import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//
class Returns extends StatelessWidget {
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
                .collection('returns')
                .where('manufacturerId', isEqualTo: manufacturerId)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((doc) {
                          double amount =
                              doc['price'] * doc['return_quantity'] * 0.65;
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 15),
                            child: Card(
                                color: Color(0xffD5EAEF),
                                child: ListTile(
                                  leading: Icon(Icons.shopping_bag_rounded,
                                      size: 30, color: Color(0xff265D80)),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text("Product: " + doc['productName'],
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
                                          "Return Quantity: " +
                                              doc['return_quantity'].toString(),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Price: \u{20B9}" +
                                              doc['price'].toString() +
                                              "/product",
                                        ),
                                        SizedBox(height: 10),
                                        Text("pickup Address: " +
                                            doc['address']),
                                        SizedBox(height: 10),
                                        Text("Amount to be paid: \u{20B9}" +
                                            amount.toString()),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                            onPressed: () {},
                                            child: Text("Accept Returns"))
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
