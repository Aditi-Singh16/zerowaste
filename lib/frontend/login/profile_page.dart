import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:scratcher/scratcher.dart';
import 'package:zerowaste/backend/local_data.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/manufacturer/scratchcard.dart';
import 'package:zerowaste/frontend/Helpers/profile_helpers/details_tab.dart';
import 'package:zerowaste/frontend/Helpers/profile_helpers/esv_tab.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';
import 'package:zerowaste/frontend/constants.dart';
import 'package:zerowaste/frontend/ngo/my_requirements.dart';
import 'package:zerowaste/frontend/ngo/all_ngo_requirements.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HelperFunctions _helperFunctions = HelperFunctions();
  var uid;

  void setUserData() async {
    var res = await HelperFunctions().readUserIdPref();
    setState(() {
      uid = res;
    });
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .where('uid', isEqualTo: uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    leading: Image.asset(
                      'assets/images/logo1.png',
                      fit: BoxFit.contain,
                    ),
                    title: Text("Profile")),
                body: SingleChildScrollView(
                    child: Column(children: [
                  (snapshot.data.docs[0].data()['type'] == 'Consumer')
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
                                            Text(
                                                '${snapshot.data.docs[0].data()['name']}',
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
                                        Row(children: <Widget>[
                                          const Text(
                                            "Available Balance",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text(
                                            'Rs. ${snapshot.data.docs[0].data()['wallet']}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
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
                  const SizedBox(
                    height: 16,
                  ),
                  (snapshot.data.docs[0].data()['type'] == 'Consumer')
                      ? Container(
                          margin: const EdgeInsets.all(40),
                          child: ESVTab(
                            air: snapshot.data.docs[0]
                                .data()['esv_air']
                                .toDouble(),
                            co2: snapshot.data.docs[0]
                                .data()['esv_co2']
                                .toDouble(),
                            tree: snapshot.data.docs[0]
                                .data()['esv_tree']
                                .toDouble(),
                            textColor: AppColor.text,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.87,
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
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DetailsFieldTab(
                                  field: "Name: ",
                                  name: snapshot.data.docs[0].data()['name']),
                              DetailsFieldTab(
                                  field: "Email: ",
                                  name: snapshot.data.docs[0].data()['email']),
                              DetailsFieldTab(
                                  field: "Role: ",
                                  name: snapshot.data.docs[0].data()['type']),
                              DetailsFieldTab(
                                  field: "Address: ",
                                  name: snapshot.data.docs[0].data()['addr']),
                              DetailsFieldTab(
                                  field: "Phone: ",
                                  name: snapshot.data.docs[0].data()['phone']),
                            ],
                          ),
                        ),
                        (snapshot.data.docs[0].data()['type'] == 'NGO')
                            ? MyRequirements(
                                uid: uid!,
                              )
                            : Container(),
                        SizedBox(height: 20),
                        (snapshot.data.docs[0].data()['type'] == 'NGO')
                            ? AllRequirements(uid: uid!)
                            : Container(),
                        (snapshot.data.docs[0].data()['type'] == 'Consumer')
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
                                            color: (snapshot.data.docs[0]
                                                    .data()['coupons']
                                                    .isNotEmpty)
                                                ? Colors.black
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.black12,
                                    margin: EdgeInsets.all(20),
                                    color: (snapshot.data.docs[0]
                                            .data()['coupons']
                                            .isNotEmpty)
                                        ? Colors.blue
                                        : Color.fromARGB(255, 109, 106, 106),
                                  ),
                                ),
                                onTap: (snapshot.data.docs[0]
                                        .data()['coupons']
                                        .isNotEmpty)
                                    ? () async {
                                        int randomindex = Random().nextInt(
                                            snapshot.data.docs[0]
                                                .data()['coupons']
                                                .length);
                                        await showScratchCard(
                                            context,
                                            snapshot.data.docs[0]
                                                    .data()['coupons']
                                                [randomindex]);
                                      }
                                    : null,
                              )
                            : Container(),
                      ],
                    ),
                  ),
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
    await DataBaseHelper.instance.deleteUser(userId);
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _copyToClipboard(String textt) async {
    await Clipboard.setData(ClipboardData(text: textt));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  showScratchCard(BuildContext context, String coupon) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ScratchCard(
            coupon: coupon,
          );
        });
  }
}
