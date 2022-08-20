// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scratcher/widgets.dart';

import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/frontend/requirements_sell/send_notif.dart';

class ViewRequirements extends StatefulWidget {
  const ViewRequirements({Key? key}) : super(key: key);

  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
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
  String userType = "NGO";
  late int randomindex;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _showMyDialog(QueryDocumentSnapshot user) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return SendNotification(user: user);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   title: Text("View Requirements"),
        //   backgroundColor: Color(0xff001427),
        // ),
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
                    child: const Text('Consumer'),
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
                      userType = "Consumer";
                    } else if (index == 1 && !_selections[index]) {
                      userType = "NGO";
                    }
                  });
                },
              ),
              userType == "NGO"
                  ? SingleChildScrollView(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('requirements')
                              .where("type", isEqualTo: "NGO")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
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
                                                    snapshot.data!.docs[i]);
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
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                        );
                                      });
                                case ConnectionState.done:
                                  return Container();
                              }
                            }
                          }),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('requirements')
                          .where("type", isEqualTo: "Consumer")
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
                                          onPressed: () {},
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
