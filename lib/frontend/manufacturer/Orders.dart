import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collectionGroup('Orders')
            .where('manufacturerId', isEqualTo: "unfoWBpH8AidhiSmwx44")
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            //print(snapshot.data!.docs.length);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("Your Orders"),
                leading: Icon(Icons.arrow_back),
                backgroundColor: Color(0xff265D80),
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
                      height: MediaQuery.of(context).size.height / 5.9,
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
                            children: [
                              Container(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      doc['image'],
                                      fit: BoxFit.fitHeight,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.6,
                                      width: MediaQuery.of(context).size.width /
                                          3.6,
                                      //color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 30,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  ////////////////////////////////////////////
                                  children: [
                                    Padding(
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
                                                  180),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
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
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          55,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                90),
                                    Container(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Quantity: " +
                                                    doc['Quantity'].toString(),
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          50,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "\u{20B9}" +
                                                    doc
                                                        .data()!['price']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          40,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          (doc['delivery_status'] ==
                                                  "Delivered")
                                              ? Text(
                                                  "Delivered",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      background: Paint()
                                                        ..color = Colors
                                                            .green.shade100
                                                        ..strokeWidth = 20
                                                        ..style = PaintingStyle
                                                            .stroke,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              50,
                                                      color: Colors.green[600]),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  "Shipped",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      background: Paint()
                                                        ..color = Colors
                                                            .orange.shade100
                                                        ..strokeWidth = 20
                                                        ..style = PaintingStyle
                                                            .stroke,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              50,
                                                      color:
                                                          Colors.orange[600]),
                                                  textAlign: TextAlign.center,
                                                ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //     height: MediaQuery.of(context)
                                    //             .size
                                    //             .height /
                                    //         70),
                                    // Row(
                                    //   children: [
                                    //     Padding(
                                    //         padding: EdgeInsets.only(),
                                    //         child: Column(
                                    //           children: [
                                    //             Text(
                                    //               "Order Date: ",
                                    //               style: TextStyle(
                                    //                 fontSize: MediaQuery.of(
                                    //                             context)
                                    //                         .size
                                    //                         .height /
                                    //                     55,
                                    //                 color: Colors.grey,
                                    //               ),
                                    //             ),
                                    //             Text(
                                    //               doc['Date'],
                                    //               style: TextStyle(
                                    //                 fontSize: MediaQuery.of(
                                    //                             context)
                                    //                         .size
                                    //                         .height /
                                    //                     55,
                                    //                 color: Colors.black,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         )),
                                    //     SizedBox(width: 70),
                                    //     Text(
                                    //       "Details >",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           background: Paint()
                                    //             ..color = Colors.black
                                    //             ..strokeWidth = 0.8
                                    //             ..style =
                                    //                 PaintingStyle.stroke,
                                    //           fontSize:
                                    //               MediaQuery.of(context)
                                    //                       .size
                                    //                       .height /
                                    //                   50,
                                    //           color: Colors.black),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                  //////////////////////////////////////////////////////////////////////////
                                ),
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
