import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  String title = "";
  bool isEditable = false;

  String phone = "";
  bool isEditablePhone = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      title = '${loggedInUser.addr}';
      phone = '${loggedInUser.phone}';
      setState(() {});
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
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
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
}
