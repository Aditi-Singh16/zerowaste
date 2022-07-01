import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//
class Orders extends StatelessWidget {
  String manufacturerId = 'unfoWBpH8AidhiSmwx44';
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          leading: Icon(Icons.arrow_back),
          backgroundColor: Color(0xff265D80),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup('Orders')
                .where('manufacturerId', isEqualTo: manufacturerId)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 15),
                            child: Card(
                                color: Color(0xffD5EAEF),
                                child: ListTile(
                                  leading: Icon(Icons.shop,
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Quantity: " +
                                              doc.data()!['Quantity'],
                                        ),
                                        Text(
                                          "Amount: \u{20B9}" +
                                              doc.data()!['Amount'].toString() +
                                              "/product",
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  : CircularProgressIndicator();
            }));
  }
}
