// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scratcher/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import "dart:math";

import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/frontend/consumer/style.dart';

class ViewRequirements extends StatefulWidget {
  const ViewRequirements({Key? key}) : super(key: key);

  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
  List<bool> _selections = [true, false];
  TextEditingController _quantityController = TextEditingController();
  List coupon = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  List description = [
    'Get 5% off on next purchase',
    'Get 10% off on next purchase',
    'Get 15% off on next purchase',
    'Get 20% off on next purchase',
    'Get 2% off on next purchase'
  ];
  List Value = [5, 10, 15, 20, 2];
  String userType = "NGO";
  late int randomindex;
  String uid = 'bcbF3NkrUnQqqeqO49pb';

  Future<void> _showMyDialog(Map<String, dynamic> user) async {
    print(user['uid']);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("pending_requirements")
                          .doc(user[uid])
                          .set({
                        "uid": user[uid],
                        "requirement_satisfy": FieldValue.arrayUnion([
                          {
                            'email': user['email'],
                            'quantity': user['quantity'],
                          }
                        ])
                      }, SetOptions(merge: true)).then((_) {
                        print("success!");
                      });

                      final Email email = Email(
                        body:
                            'Hi ${user['name']} I have the whole quantity of the product you require!',
                        subject: 'Request Fulfilment',
                        recipients: [user['email']],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email).then((val) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Emaile sent successfully!'),
                          duration: const Duration(seconds: 5),
                        ));
                      });
                    },
                    child: Text('I have the whole quantity')),
                Text('OR Enter custom quantity'),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Connect!'),
              onPressed: () async {
                if (_quantityController.text != '') {
                  await FirebaseFirestore.instance
                      .collection("pending_requirements")
                      .doc(user[uid])
                      .set({
                    "uid": user[uid],
                    "requirement_satisfy": FieldValue.arrayUnion([
                      {
                        'email': user[
                            'email'], //loggedin user ka email after shared pref
                        'quantity': int.parse(_quantityController.text)
                      }
                    ])
                  }, SetOptions(merge: true)).then((_) {
                    print("success!");
                  });

                  final Email email = Email(
                    body:
                        'Hi ${user['name']} I have ${_quantityController.text} of the product you require!',
                    subject: 'Request Fulfilment',
                    recipients: [user['email']],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email).then((val) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Emaile sent successfully!'),
                      duration: const Duration(seconds: 5),
                    ));
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("View Requirements"),
          backgroundColor: Color(0xff001427),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ToggleButtons(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('NGO'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('My Requirements'),
                  ),
                ],
                isSelected: _selections,
                onPressed: (int index) {
                  setState(() {
                    _selections = _selections.reversed.toList();
                    if (index == 0 && _selections[index]) {
                      userType = "NGO";
                    } else if (index == 0 && !_selections[index]) {
                      userType = "NGO";
                    } else if (index == 1 && _selections[index]) {
                      userType = "MyRequirements";
                    } else if (index == 1 && !_selections[index]) {
                      userType = "NGO";
                    }
                  });
                },
              ),
              userType == "NGO"
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('requirements')
                          .where("type", isEqualTo: "NGO")
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
                                color: Colors.pink,
                                size: 50.0,
                              );

                            case ConnectionState.active:
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    return Card(
                                      child: ListTile(
                                        leading: SvgPicture.asset(
                                            'assets/icons/${snapshot.data!.docs[i]['category']}.svg',
                                            width: 70.0,
                                            height: 70.0),
                                        title: Text(
                                            '${snapshot.data!.docs[i]['product_name']}'),
                                        subtitle: Text(
                                            'Quantity: ${snapshot.data!.docs[i]['quantity']}'),
                                        trailing: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Color(
                                                0xff5CAD81), // Background Color
                                          ),
                                          child: Text(
                                            "I got this!",
                                            style: TextStyle(
                                                color: Color(0xff001427)),
                                          ),
                                          onPressed: () async {
                                            _showMyDialog(
                                                snapshot.data!.docs[i].data());
                                            // randomindex =
                                            //     Random().nextInt(coupon.length);
                                            // showScratchCard(context);
                                            // String couponn = "Coupon" +
                                            //     (randomindex).toString();

                                            // await FirebaseFirestore.instance
                                            //     .collection('Users')
                                            //     .doc(uid)
                                            //     .update({couponn: true});
                                          },
                                        ),
                                      ),
                                      elevation: 8,
                                      margin: EdgeInsets.all(10),
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                    );
                                  });
                            case ConnectionState.done:
                              return Container();
                          }
                        }
                      })
                  : StreamBuilder(
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
                                color: Colors.pink,
                                size: 50.0,
                              );

                            case ConnectionState.active:
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    //print(snapshot.data!.docs.length);
                                    DocumentSnapshot doc =
                                        snapshot.data!.docs[index];
                                    // print("Doc ID");
                                    // print(doc.id);
                                    // print("Doc length");
                                    // print(doc['requirement_satisfy'].length);
                                    // for (int i = 0; i < snapshot.data!.docs.length; i++) {
                                    //   if (snapshot.data!.docs[index]['requirement_satisfy']
                                    //           .length >
                                    //       0) header = true;
                                    // }
                                    return Column(children: [
                                      // header ? Text("My Requirements")  : SizedBox(width: 0),

                                      ListView.builder(
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
                                                                                doc['product_name'],
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
                                                                                () {
                                                                              setState(() {
                                                                                FirebaseFirestore.instance.collection("requirements").doc(doc.id).update({
                                                                                  "is_satisfied": true
                                                                                });
                                                                                FirebaseFirestore.instance.collection("requirements").doc(doc.id).update({
                                                                                  "requirement_satisfy": []
                                                                                });
                                                                              });
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
