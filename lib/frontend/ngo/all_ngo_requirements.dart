// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scratcher/widgets.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/frontend/consumer/style.dart';

class AllRequirements extends StatefulWidget {
  const AllRequirements({Key? key}) : super(key: key);

  @override
  State<AllRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<AllRequirements> {
  HelperFunctions _helperFunctions = HelperFunctions();
  List<bool> _selections = [true, false];
  List coupon = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  List description = [
    'Get 5% off on next purchase',
    'Get 10% off on next purchase',
    'Get 15% off on next purchase',
    'Get 20% off on next purchase',
    'Get 2% off on next purchase'
  ];
  List Value = [5, 10, 15, 20, 2];

  late int randomindex;
  String uid = "";

  setUID() async {
    String user = await HelperFunctions().readUserIdPref();
    setState(() {
      uid = user;
    });
  }

  @override
  void initState() {
    setUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requirements')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Loader();
              case ConnectionState.waiting:
                return const Loader();
              case ConnectionState.active:
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return !doc.data()!.containsKey('requirement_satisfy')
                          ? Container()
                          : Column(
                              children: [
                                Text(
                                  'Completed Requirements',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        doc['requirement_satisfy'].length,
                                    itemBuilder: (context, idx) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5.9,
                                        child: Card(
                                          margin: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  80),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    ////////////////////////////////////////////
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                30),
                                                        child: Padding(
                                                            padding: EdgeInsets
                                                                .only(),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Column(
                                                                          children: [
                                                                            Text("Manufacturer Email:"),
                                                                            Text(
                                                                              doc['requirement_satisfy'][idx]['email'],
                                                                              maxLines: 2,
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).size.height / 50,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            )
                                                                          ]),
                                                                      const Spacing(),
                                                                      Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            Text(
                                                                              "In Stock: ",
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).size.height / 55,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              doc['requirement_satisfy'][idx]['quantity'],
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).size.height / 50,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            //const Spacing(),
                                                                            SizedBox(
                                                                              width: 12,
                                                                            ),
                                                                            Text(
                                                                              "Product Name: ",
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).size.height / 55,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              doc['requirement_satisfy'][idx]['product_name'],
                                                                              style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).size.height / 50,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ],
                                                                  ),
                                                                  FlatButton(
                                                                      color: Colors
                                                                          .green,
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          String
                                                                              accepted_uid =
                                                                              doc['requirement_satisfy'][idx]['uid'];
                                                                          print(
                                                                              accepted_uid);

                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection("Users")
                                                                              .doc(accepted_uid)
                                                                              .update({
                                                                            "Count":
                                                                                FieldValue.increment(1),
                                                                            "accepted_requests":
                                                                                FieldValue.arrayUnion([
                                                                              {
                                                                                "category": doc['category'],
                                                                                "quantity": doc['quantity'].toString(),
                                                                                "email": doc['requirement_satisfy'][idx]['email']
                                                                              }
                                                                            ])
                                                                          });

                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection("requirements")
                                                                              .doc(doc.id)
                                                                              .delete();
                                                                        });
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection("Users")
                                                                            .doc(uid)
                                                                            .set({
                                                                          "donor":
                                                                              FieldValue.increment(1),
                                                                        }, SetOptions(merge: true));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Order",
                                                                        style: AppStyle.bodyText.copyWith(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 16),
                                                                      )),
                                                                ])),
                                                      ),
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
                              ],
                            );
                    });

              case ConnectionState.done:
                return Container();
            }
          }
        });
  }
}
