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
                              color: Color(0xFFCDF0EA),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Name: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.name}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "Email: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.email}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text(
                                      "Role: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${loggedInUser.type}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Expanded(
                                      child: !isEditable
                                          ? Text(
                                              title,
                                              style: TextStyle(fontSize: 20),
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
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Expanded(
                                      child: !isEditablePhone
                                          ? Text(
                                              phone,
                                              style: TextStyle(fontSize: 20),
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
                  loggedInUser.type == 'Consumer' || loggedInUser.type == 'NGO'
                      ? Text(
                          "My Requirements",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 50,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(""),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //print(snapshot.data!.docs.length);
                        DocumentSnapshot doc = snapshot.data!.docs[index];
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
                              itemCount: doc['requirement_satisfy'].length,
                              itemBuilder: (context, idx) {
                                //print(snapshot.data!.docs.length);

                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  height:
                                      MediaQuery.of(context).size.height / 5.9,
                                  child: Card(
                                    margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.height /
                                            80),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              30),
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.only(),
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
                                                                      Text(
                                                                          "Manufacturer Email:"),
                                                                      Text(
                                                                        doc['requirement_satisfy'][idx]
                                                                            [
                                                                            'email'],
                                                                        maxLines:
                                                                            2,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height / 50,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      )
                                                                    ]),
                                                                const Spacing(),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Text(
                                                                        "In Stock: ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height / 55,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        doc['requirement_satisfy'][idx]
                                                                            [
                                                                            'quantity'],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height / 50,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      //const Spacing(),
                                                                      SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Text(
                                                                        "Product Name: ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height / 55,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        doc['product_name'],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.height / 50,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ],
                                                            ),
                                                            FlatButton(
                                                                color: Colors
                                                                    .green,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "requirements")
                                                                        .doc(doc
                                                                            .id)
                                                                        .update({
                                                                      "is_satisfied":
                                                                          true
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "requirements")
                                                                        .doc(doc
                                                                            .id)
                                                                        .update({
                                                                      "requirement_satisfy":
                                                                          []
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Satisfy",
                                                                  style: AppStyle
                                                                      .bodyText
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16),
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
                      }),
                  const Spacing(),
                  FloatingActionButton(
                    onPressed: () {
                      logout();
                    },
                    child: Icon(Icons.logout_rounded),
                    backgroundColor: Colors.green,
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
