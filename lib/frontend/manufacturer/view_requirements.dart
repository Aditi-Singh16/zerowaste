// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/requirements_sell/send_notif.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ViewRequirements extends StatefulWidget {
  ViewRequirements({
    Key? key,
    this.user,
  }) : super(key: key);

  dynamic user;
  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
  HelperFunctions _helperFunctions = HelperFunctions();
  List<bool> _selections = [true, false];
  TextEditingController _quantityController = TextEditingController();

  String userType = "NGO";

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
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requirements')
                  .where("type",
                      isEqualTo: userType == "NGO" ? "NGO" : "Consumer")
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text('something went wrong');
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Loader();
                    case ConnectionState.waiting:
                      return Loader();

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
                                      backgroundColor:
                                          Color(0xff5CAD81), // Background Color
                                    ),
                                    child: Text(
                                      userType == "NGO" ? "I got this!" : "Add",
                                      style:
                                          TextStyle(color: Color(0xff001427)),
                                    ),
                                    onPressed: () async {
                                      if (userType == "NGO") {
                                        _showMyDialog(snapshot.data!.docs[i]);
                                      } else {
                                        //notify email to consumer
                                        final Email email = Email(
                                          body:
                                              'Hi, ${snapshot.data!.docs[i]['product_name']} has been added to our product list!!',
                                          subject: 'Request Fulfilment',
                                          recipients: [
                                            snapshot.data!.docs[i]['email']
                                          ],
                                          isHTML: false,
                                        );

                                        await FlutterEmailSender.send(email)
                                            .then((val) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'Email sent successfully!'),
                                            duration:
                                                const Duration(seconds: 5),
                                          ));
                                        });
                                      }
                                    }),
                              ),
                              elevation: 8,
                              margin: EdgeInsets.all(10),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
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
}
