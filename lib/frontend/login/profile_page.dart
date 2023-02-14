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
import 'package:zerowaste/frontend/consumer/details.dart';

import 'package:zerowaste/frontend/login/login.dart';
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
  int randomindex = 0;
  List coupon = ['OFF5', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];

  bool reward = true;

  late UserModel currUser;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      title = '${loggedInUser.addr}';
      phone = '${loggedInUser.phone}';
      type = loggedInUser.type!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('requirements')
            .where('uid', isEqualTo: loggedInUser.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                    leading: Image.asset(
                      'assets/images/logo1.png',
                      fit: BoxFit.contain,
                    ),
                    title: Text("Profile")),
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
                                            'Rs.' +
                                                loggedInUser.wallet.toString(),
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
                  (type == 'Consumer')
                      ? Container(
                          margin: const EdgeInsets.all(40),
                          child: ESVTab(
                            air: loggedInUser.esv_air!,
                            co2: loggedInUser.esv_co2!,
                            tree: loggedInUser.esv_tree!,
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
                                  field: "Name: ", name: loggedInUser.name!),
                              DetailsFieldTab(
                                  field: "Email: ", name: loggedInUser.email!),
                              DetailsFieldTab(
                                  field: "Role: ", name: loggedInUser.type!),
                              DetailsFieldTab(
                                  field: "Address: ", name: loggedInUser.addr!),
                              DetailsFieldTab(
                                  field: "Phone: ", name: loggedInUser.phone!),
                            ],
                          ),
                        ),
                        (type == 'NGO')
                            ? MyRequirements(
                                uid: loggedInUser.uid!,
                              )
                            : Container(),
                        SizedBox(height: 20),
                        (type == 'NGO')
                            ? AllRequirements(uid: loggedInUser.uid!)
                            : Container(),
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
                                            color: (loggedInUser
                                                    .coupons!.isNotEmpty)
                                                ? Colors.black
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.black12,
                                    margin: EdgeInsets.all(20),
                                    color: (loggedInUser.coupons!.isNotEmpty)
                                        ? Colors.blue
                                        : Color.fromARGB(255, 109, 106, 106),
                                  ),
                                ),
                                onTap: (loggedInUser.coupons!.isNotEmpty)
                                    ? () async {
                                        randomindex = Random().nextInt(
                                            AppConstants.coupons.length);
                                        await showScratchCard(
                                            context, randomindex);
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

  showScratchCard(BuildContext context, int randomindex) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ScratchCard(
            randomindex: randomindex,
          );
        });
  }
}
