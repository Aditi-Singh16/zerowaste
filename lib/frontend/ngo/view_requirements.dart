// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scratcher/widgets.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';
import 'package:zerowaste/frontend/consumer/details.dart';

import 'package:zerowaste/frontend/consumer/style.dart';

import 'package:zerowaste/frontend/requirements_sell/send_notif.dart';

class ViewRequirements extends StatefulWidget {
  const ViewRequirements({Key? key}) : super(key: key);

  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("View Requirements"),
          backgroundColor: Color(0xff001427),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
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
                          print(uid);
                          print(snapshot.data);
                          print(snapshot.data!.docs.length);
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                print(snapshot.data!.docs.length);
                                DocumentSnapshot doc =
                                    snapshot.data!.docs[index];
                                return Column(children: [
                                  // header ? Text("My Requirements")  : SizedBox(width: 0),
                                  doc['requirement_satisfy'].length == 0
                                      ? Container()
                                      : ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              doc['requirement_satisfy'].length,
                                          itemBuilder: (context, idx) {
                                            //print(snapshot.data!.docs.length);

                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
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
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Column(children: [
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
                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                                                                              setState(() {
                                                                                String accepted_uid = doc['requirement_satisfy'][idx]['uid'];
                                                                                print(accepted_uid);

                                                                                FirebaseFirestore.instance.collection("Users").doc(accepted_uid).update({
                                                                                  "Count": FieldValue.increment(1),
                                                                                  "accepted_requests": FieldValue.arrayUnion([
                                                                                    {
                                                                                      "category": doc['category'],
                                                                                      "quantity": doc['quantity'].toString(),
                                                                                      "email": doc['requirement_satisfy'][idx]['email']
                                                                                    }
                                                                                  ])
                                                                                });

                                                                                FirebaseFirestore.instance.collection("requirements").doc(doc.id).delete();
                                                                              });
                                                                              await FirebaseFirestore.instance.collection("Users").doc(uid).set({
                                                                                "donor": FieldValue.increment(1),
                                                                              }, SetOptions(merge: true));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "Order",
                                                                              style: AppStyle.bodyText.copyWith(color: Colors.white, fontSize: 16),
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
                                ]);
                              });

                        case ConnectionState.done:
                          return Container();
                      }
                    }
                  })
            ],
          ),
        ));
  }

  showScratchCard(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Scratcher(
              brushSize: 100,
              threshold: 50,
              color: Colors.blue,
              onChange: (value) => print("Scratch progress: $value%"),
              onThreshold: () => print("Threshold reached"),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.42,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset(
                        "assets/images/cele.png",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You\'ve won",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            letterSpacing: 1,
                            color: Colors.blue),
                      ),
                    ),
                    Spacing(),
                    Text(
                      coupon[randomindex],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.blue),
                    ),
                    Spacing(),
                    Text(
                      description[randomindex],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
