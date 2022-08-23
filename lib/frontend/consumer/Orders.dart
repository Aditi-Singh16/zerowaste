import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/consumer/learning_modules/learningMod.dart';
import 'package:zerowaste/frontend/consumer/return.dart';
import 'package:zerowaste/frontend/consumerNavbar.dart';
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
    return StreamBuilder<QuerySnapshot>(
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ConsumerNavbar()));
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
                      title: Text("Your Orders"),
                      automaticallyImplyLeading: false,
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
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Image.network(
                                            doc['image'],
                                            fit: BoxFit.fitHeight,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.6,
                                            //color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          30,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            180),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      doc['ProductName'],
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            50,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      doc['Date'],
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  90),
                                          Container(
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Quantity: " +
                                                          doc['Quantity']
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
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
                                                        fontSize: MediaQuery.of(
                                                                    context)
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
                                                                  orderedQuantity:
                                                                      doc['Quantity']
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
                                                          Scaffold.of(context)
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
                                                      )
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
              case ConnectionState.done:
                return Container();
            }
          }
          // return Scaffold(
          //     body:
          //         Center(child: CircularProgressIndicator(color: Colors.grey)));
        });
  }
}
