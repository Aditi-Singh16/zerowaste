import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scratcher/scratcher.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/frontend/consumer/style.dart';
import 'package:zerowaste/frontend/login/login.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HelperFunctions _helperFunctions = HelperFunctions();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool header = false;
  var name = HelperFunctions().readNamePref();
  String type = '';
  String title = "";
  int count = 0;
  bool isEditable = false;
  List<dynamic> rewards = [];
  String phone = "";
  late int randomindex;
  List coupon = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  List description = [
    'Get 5% off on next purchase',
    'Get 10% off on next purchase',
    'Get 15% off on next purchase',
    'Get 20% off on next purchase',
    'Get 2% off on next purchase'
  ];

  List Value = [5, 10, 15, 20, 2];
  bool isEditablePhone = false;
  bool reward = false;
  @override
  Future<void> fetch_validity() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      setState(() {
        count = data['Count'];
      });
      print('HIIII');
      print(count);
    }
  }

  void initState() {
    super.initState();
    fetch_validity();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      title = '${loggedInUser.addr}';
      phone = '${loggedInUser.phone}';
      type = loggedInUser.type!;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? uid = loggedInUser.uid;
    print(uid);
    print(_helperFunctions.readNamePref());

    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('requirements')
            .where('uid', isEqualTo: uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Profile"),
                  leading: Icon(Icons.arrow_back),
                  backgroundColor: Color(0xff265D80),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue.shade100,
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Name: ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff00277d),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.name}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff00277d),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "Email: ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff00277d),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${loggedInUser.email}',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff00277d),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text(
                                      "Role: ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff00277d),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.type}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff00277d),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff00277d),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                      child: !isEditable
                                          ? Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff00277d),
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : TextFormField(
                                              initialValue: title,
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) {
                                                setState(
                                                  () => {
                                                    isEditable = false,
                                                    title = value,
                                                    FirebaseFirestore.instance
                                                        .collection("Users")
                                                        .doc(loggedInUser.uid)
                                                        .update({"addr": value})
                                                  },
                                                );

                                                //print(_helperFunctions.readNamePref());
                                              })),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() => {
                                            isEditable = true,
                                          });
                                    },
                                  )
                                ]),
                                // SizedBox(height: 10),
                                Row(children: [
                                  Text(
                                    "Phone: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff00277d),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                      child: !isEditablePhone
                                          ? Text(
                                              phone,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff00277d),
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : TextFormField(
                                              initialValue: phone,
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) {
                                                setState(
                                                  () => {
                                                    isEditablePhone = false,
                                                    phone = value,
                                                    FirebaseFirestore.instance
                                                        .collection("Users")
                                                        .doc(loggedInUser.uid)
                                                        .update(
                                                            {"phone": value})
                                                  },
                                                );

                                                //print(_helperFunctions.readNamePref());
                                              })),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() => {
                                            isEditablePhone = true,
                                          });
                                    },
                                  )
                                ]),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        (type == 'Consumer')
                            ? Text(
                                'Rewards',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(''),
                        const Spacing(),
                        (type == 'Consumer')
                            ? TextButton(
                                onPressed: () {
                                  reward = true;

                                  if (loggedInUser.Coupon0 == true) {
                                    rewards.add('OFF05');
                                  }
                                  if (loggedInUser.Coupon1 == true) {
                                    rewards.add('OFF10');
                                  }
                                  if (loggedInUser.Coupon2 == true) {
                                    rewards.add('OFF15');
                                  }
                                  if (loggedInUser.Coupon3 == true) {
                                    rewards.add('OFF20');
                                  }
                                  if (loggedInUser.Coupon4 == true) {
                                    rewards.add('OFF02');
                                  }
                                },
                                child: Text(
                                  'View Rewards',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      letterSpacing: 1.25),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: (MaterialStateProperty.all(
                                      Color(0xff265D80),
                                    )),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ))),
                              )
                            : Text(''),
                        const Spacing(),
                        (reward)
                            ? Column(
                                children: rewards.map((data) {
                                  return InkWell(
                                    child: Container(
                                      margin: EdgeInsets.all(15.0),
                                      padding: EdgeInsets.all(17.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: const Offset(
                                              0,
                                              3,
                                            ),
                                            blurRadius: 5.0,
                                            spreadRadius: 0.2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(Icons.info_outline_rounded)
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : Visibility(visible: false, child: Text(' ')),
                        TextButton(
                          onPressed: (count > 0)
                              ? () async {
                                  String couponn = '';

                                  randomindex = Random().nextInt(coupon.length);
                                  showScratchCard(context);
                                  couponn = "Coupon" + (randomindex).toString();

                                  setState(() {
                                    if (!rewards.contains(couponn)) {
                                      rewards.add(coupon[randomindex]);

                                      count--;
                                    }
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(uid)
                                      .update({
                                    couponn: true,
                                    'Count': FieldValue.increment(-1),
                                  });
                                }
                              : null,
                          child: Text(
                            'Click me to get Reward',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                letterSpacing: 1.25),
                          ),
                          style: (count > 0)
                              ? ButtonStyle(
                                  backgroundColor: (MaterialStateProperty.all(
                                    Color(0xff265D80),
                                  )),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )))
                              : ButtonStyle(
                                  backgroundColor: (MaterialStateProperty.all(
                                    Color.fromARGB(255, 101, 126, 141),
                                  )),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ))),
                        ),
                      ],
                    ),
                  ),

                  // const Spacing(),

                  FloatingActionButton(
                    onPressed: () {
                      logout();
                    },
                    child: Icon(Icons.logout_rounded),
                    backgroundColor: Color(0xff3472c0),
                  ),
                ])));
          }
          return Scaffold(
              body: Center(
                  child: SpinKitChasingDots(
            color: Colors.blue,
            size: 50.0,
          )));
        });
  }

  // the logout function
  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
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
