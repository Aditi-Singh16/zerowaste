import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

//
class ManuFactureOrders extends StatefulWidget {
  @override
  State<ManuFactureOrders> createState() => _ManuFactureOrdersState();
}

class _ManuFactureOrdersState extends State<ManuFactureOrders> {
  var manufacturerId = "";

  final db = FirebaseFirestore.instance;

  void setManufacturerId() async {
    var id = await HelperFunctions().readUserIdPref();
    setState(() {
      manufacturerId = id;
    });
    print(manufacturerId);
  }

  _showMyDialog(var rate) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Return rate is $rate %"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    setManufacturerId();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                                color: const Color(0xffD5EAEF),
                                child: ListTile(
                                  leading: const Icon(
                                      CupertinoIcons.cube_box_fill,
                                      size: 30,
                                      color: Color(0xff265D80)),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Product: " +
                                            doc.data()!['ProductName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Quantity: " +
                                              doc
                                                  .data()!['Quantity']
                                                  .toString(),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Amount: \u{20B9}" +
                                              ((doc.data()!['Amount'] - 20) /
                                                      doc.data()!['Quantity'])
                                                  .toString() +
                                              "/product",
                                        ),
                                        SizedBox(height: 5),
                                        Text("Delivery Address: " +
                                            doc.data()!['address']),
                                        SizedBox(height: 5),
                                        Text("Phone Number: " +
                                            doc.data()!['phone_no']),
                                        ElevatedButton(
                                            onPressed: () async {
                                              var numer = 0.0;
                                              var deno = 0.0;
                                              var returned =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collectionGroup('Orders')
                                                      .get();
                                              returned.docs.forEach((element) {
                                                //print(element.data()!['Quantity']);
                                                numer = numer +
                                                    element.data()!['Quantity'];
                                              });
                                              var bought =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Users')
                                                      .doc(doc.data()!['uid'])
                                                      .collection('Orders')
                                                      .where("is_return",
                                                          isEqualTo: true)
                                                      .get();
                                              bought.docs.forEach((element) {
                                                deno = deno +
                                                    element.data()!['Quantity'];
                                              });
                                              var rate = numer / deno;
                                              if (deno == 0) {
                                                rate = 0;
                                              }

                                              _showMyDialog(rate);
                                            },
                                            child: Text('Return Rate'))
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  : const Loader();
            }));
  }
}
