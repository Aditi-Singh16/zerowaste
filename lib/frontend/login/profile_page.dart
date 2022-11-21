import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:scratcher/scratcher.dart';
import 'package:zerowaste/backend/local_data.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/profile_helpers/details_tab.dart';
import 'package:zerowaste/frontend/Helpers/profile_helpers/esv_tab.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/analytics.dart';
import 'package:zerowaste/frontend/consumer/color.dart';
import 'package:zerowaste/frontend/consumer/details.dart';

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
  double wallet = 0.0;
  bool isEditable = false;
  List<dynamic> rewards = [];
  String phone = "";
  late int randomindex;
  List coupon = ['OFF5', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  double air = 0.0;
  double co2 = 0.0;
  double tree = 0.0;
  List description = [
    'Get 2% off on next purchase'
        'Get 5% off on next purchase',
    'Get 10% off on next purchase',
    'Get 15% off on next purchase',
    'Get 20% off on next purchase',
  ];
  Map category = {
    'Books': 50,
    'Electronics': 5,
    'Recycled Products': 7,
    'Cotton Clothes': 5,
    'Nylon Clothes': 5,
    'Silk Clothes': 5,
    'Bags': 7
  };
  List<Map<String, dynamic>> accepted_requests = [];

  List Value = [2, 5, 10, 15, 20];
  bool isEditablePhone = false;
  bool reward = true;

  late UserModel currUser;

  @override
  Future<void> fetch_validity() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();
    var docSnapshot1 = await FirebaseFirestore.instance
        .collection("environment")
        .doc(await HelperFunctions().readUserIdPref())
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      print(data);

      // You can then retrieve the value from the Map like this:
      setState(() {
        if (data['Count'] != null) {
          count = data['Count'];
          for (int i = 0; i < count; i++) {
            accepted_requests.add(data['accepted_requests'][i]);
          }
          print('heyy');
        }
        if (data['wallet'] != null) {
          wallet = data['wallet'];
        }
        if (data['Coupon0'] == true) {
          rewards.add('OFF2');
        }
        if (data['Coupon1'] == true) {
          rewards.add('OFF5');
        }
        if (data['Coupon2'] == true) {
          rewards.add('OFF10');
        }
        if (data['Coupon3'] == true) {
          rewards.add('OFF15');
        }
        if (data['Coupon4'] == true) {
          rewards.add('OFF20');
        }
      });
    }
    if (docSnapshot1.exists) {
      Map<String, dynamic> data1 = docSnapshot1.data()!;

      air = data1['air'];
      tree = data1['tree'];
      co2 = data1['co2'];
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
                  title: const Text("Profile"),
                  backgroundColor: AppColor.secondary,
                  actions: [
                    IconButton(
                        onPressed: () {
                          (type == 'Consumer')
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ConsumerAnalytics()))
                              : null;
                        },
                        icon: Icon(Icons.auto_graph_rounded))
                  ],
                ),
                body: SingleChildScrollView(
                    child: Column(children: [
                  (type == 'Consumer')
                      ? Stack(
                          children: <Widget>[
                            Column(children: <Widget>[
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.87,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 113, 199, 116),
                                            Color.fromARGB(255, 86, 153, 207)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomCenter),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Your Wallet',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${loggedInUser.name}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 23)),
                                            Image.asset(
                                              'assets/images/logo1.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.11,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 200),
                                            child: const Text(
                                              "Available Balance",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Row(children: <Widget>[
                                          Text(
                                            'Rs. ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            wallet.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ])
                          ],
                        )
                      : Visibility(visible: false, child: Text(' ')),
                  const Spacing(),
                  (type == 'Consumer')
                      ? ESVTab(air: air, co2: co2, tree: tree)
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailsFieldTab(
                                    field: "Name: ", name: loggedInUser.name!),
                                DetailsFieldTab(
                                    field: "Email: ",
                                    name: loggedInUser.email!),
                                DetailsFieldTab(
                                    field: "Role: ", name: loggedInUser.type!),
                                DetailsFieldTab(
                                    field: "Address: ",
                                    name: loggedInUser.addr!),
                                DetailsFieldTab(
                                    field: "Phone: ",
                                    name: loggedInUser.phone!),
                              ],
                            ),
                          ),
                        ),
                        (type == 'Consumer')
                            ? InkWell(
                                child: Container(
                                  height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Card(
                                    child: Center(
                                      child: Text(
                                        'Collect Reward',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: (count > 0)
                                                ? Colors.black
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.black12,
                                    margin: EdgeInsets.all(20),
                                    color: (count > 0)
                                        ? Colors.blue
                                        : Color.fromARGB(255, 109, 106, 106),
                                  ),
                                ),
                                onTap: (count > 0)
                                    ? () async {
                                        String couponn = '';
                                        String categoryy =
                                            accepted_requests[count - 1]
                                                ['category'];
                                        int quantity =
                                            accepted_requests[count - 1]
                                                ['quantity'];
                                        if (quantity >= category[categoryy]) {
                                          randomindex = 3 + Random().nextInt(2);
                                        } else {
                                          randomindex =
                                              Random().nextInt(coupon.length);
                                        }
                                        await showScratchCard(context);
                                        couponn =
                                            "Coupon" + (randomindex).toString();

                                        setState(() {
                                          if (rewards
                                              .contains(coupon[randomindex])) {
                                          } else {
                                            rewards.add(coupon[randomindex]);

                                            accepted_requests
                                                .removeAt(count - 1);
                                            count--;
                                          }
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(loggedInUser.uid)
                                            .update({
                                          couponn: true,
                                          'Count': FieldValue.increment(-1),
                                          'accepted_requests': accepted_requests
                                        });
                                      }
                                    : null,
                              )
                            : Container(),
                        (rewards.isEmpty && type == 'Consumner')
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Rewards',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Image.asset(
                                    'assets/images/donate.jpg',
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  Text(
                                    'Donate to NGO to earn rewards',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            : (type == 'Consumer')
                                ? Column(
                                    children: rewards.map((data) {
                                      return Container(
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Card(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                '${data}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.copy),
                                                onPressed: () async {
                                                  await _copyToClipboard(data);
                                                },
                                              ),
                                            ],
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.black,
                                          margin: EdgeInsets.all(20),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Container(),
                      ],
                    ),
                  ),

                  // const Spacing(),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      logout();
                    },
                    child: Icon(Icons.logout_rounded),
                    backgroundColor: AppColor.secondary,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ])));
          }
          return Loader();
        });
  }

  // the logout function
  logout() async {
    var userId = await HelperFunctions().readUserIdPref();
    await FirebaseAuth.instance.signOut();
    await DataBaseHelper.instance.deleteUser(userId);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> _copyToClipboard(String textt) async {
    await Clipboard.setData(ClipboardData(text: textt));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                    Spacing(),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await _copyToClipboard(coupon[randomindex]);
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK')),
                    Spacing(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
