import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scratcher/scratcher.dart';
import 'package:zerowaste/backend/local_data.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/color.dart';
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
      print('HIIII');
      print(count);
      print(accepted_requests);
      print(rewards);
    }
    if (docSnapshot1.exists) {
      Map<String, dynamic> data1 = docSnapshot1.data()!;

      air = data1['air'];
      tree = data1['tree'];
      co2 = data1['co2'];
      print('EV');
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
                  backgroundColor: AppColor.secondary,
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
                      ? Container(
                          margin: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'ESV (Environment Saving Values)  ',
                                      style: AppStyle.text.copyWith(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.033),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),

                                  // i icon button with alert dialogue
                                  IconButton(
                                    icon: Icon(Icons.info_outline),
                                    color: Colors.black,
                                    iconSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    alignment: Alignment.bottomRight,
                                    onPressed: () {
                                      //alert dialogue box pop up
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Center(
                                              child: RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.033),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "Approximate values per product\n\n",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02)),
                                                  TextSpan(
                                                      text:
                                                          "Air Pollution - numbers here shows the amount of air saved from making the product\n"
                                                          "Trees Saved - numbers here shows the amount of trees saved from cutting in making this product\n"
                                                          "CO2 - numbers here show the amount of CO2 saved while making this product",
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.015)),
                                                ]),
                                          )),
                                          actions: <Widget>[
                                            Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Spacing(),
                              Row(
                                children: [
                                  const Spacing(),
                                  const Spacing(),
                                  Column(
                                    children: [
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1), // Image radius
                                          child: Image.network(
                                              'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2F11zon_cropped.png?alt=media&token=72d9009f-c528-4fd5-a638-e933dffee8f9',
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text("Air Pollution"),
                                      Text(
                                        '$air' + " aqi of Air",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1), // Image radius
                                          child: Image.network(
                                              'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2FPicsart_22-08-19_12-36-20-414.png?alt=media&token=cc0c00fb-a68a-4b69-84cd-2e60fd910215',
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text("Tree"),
                                      Text(tree.toString() + "Tree saved",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                              color: Colors.black))
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1), // Image radius
                                          child: Image.network(
                                              'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2FPicsart_22-08-19_12-43-19-549.png?alt=media&token=b05f3d35-67ee-451e-8737-08e14c13c5d5',
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text("Co2"),
                                      Text(
                                          (co2.toString()).substring(0, 3) +
                                              " ppm of Co2",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                              color: Colors.black))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Text(''),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Details',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.name}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
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
                                          color: Colors.black,
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
                                            color: Colors.black,
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.type}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
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
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                      child: !isEditable
                                          ? Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : TextFormField(
                                              initialValue: title,
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) async {
                                                await HelperFunctions()
                                                    .setAddrPref(value);
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
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                      child: !isEditablePhone
                                          ? Text(
                                              phone,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : TextFormField(
                                              initialValue: phone,
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) async {
                                                await HelperFunctions()
                                                    .setPhonePref(value);
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
                                'Get Rewards',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            : Visibility(visible: false, child: Text('')),
                        const Spacing(),
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
                                        print('COUPON');
                                        setState(() {
                                          if (rewards
                                              .contains(coupon[randomindex])) {
                                            print('NO');
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
                            : Text(''),
                        const Spacing(),
                        (type == 'Consumer')
                            ? Text(
                                'Your Rewards',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(''),
                        const Spacing(),
                        (rewards.length == 0 && type == 'Consumner')
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
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
                                        fontSize: 20,
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
                                                    fontSize: 20,
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
                                : Visibility(visible: false, child: Text(' ')),
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
                    backgroundColor: Color(0xff3472c0),
                  ),
                  SizedBox(
                    height: 10,
                  )
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
    var userId = await HelperFunctions().readUserIdPref();
    await FirebaseAuth.instance.signOut();
    print(userId);
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
                          fontSize: 20,
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
