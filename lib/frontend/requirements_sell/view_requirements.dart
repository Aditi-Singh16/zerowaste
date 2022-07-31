// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewRequirements extends StatefulWidget {
  const ViewRequirements({Key? key}) : super(key: key);

  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
  final List<bool> _selections = List.generate(2, (_) => false);

  String userType = "NGO";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
            _selections[index] = !_selections[index];
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
                                  leading: SvgPicture.asset('assets/icons/${snapshot.data!.docs[i]['category']}.svg',
                                  width: 70.0, height: 70.0),
                                  title:Text('${snapshot.data!.docs[i]['product_name']}'),
                                  subtitle: Text('Quantity: ${snapshot.data!.docs[i]['quantity']}'),
                                  trailing: TextButton(
                                    style:  TextButton.styleFrom(
                                            backgroundColor: Color(0xff5CAD81), // Background Color
                                      ),
                                    child: Text(
                                      "I got this!",
                                      style: TextStyle(
                                        color: Color(0xff001427)
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              elevation: 8,
                              margin: EdgeInsets.all(10),
                              shape:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), 
                                  borderSide: BorderSide(color: Colors.white)
                              ),
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
                                  leading: SvgPicture.asset('assets/icons/${snapshot.data!.docs[i]['category']}.svg',
                                  width: 70.0, height: 70.0),
                                  title:Text('${snapshot.data!.docs[i]['product_name']}'),
                                  subtitle: Text('Quantity: ${snapshot.data!.docs[i]['quantity']}'),
                                  trailing: TextButton(
                                    style:  TextButton.styleFrom(
                                            backgroundColor: Color(0xff5CAD81), // Background Color
                                      ),
                                    child: Text(
                                      "I got this!",
                                      style: TextStyle(
                                        color: Color(0xff001427)
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              elevation: 8,
                              margin: EdgeInsets.all(10),
                              shape:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), 
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                            );
                          });
                      
                    case ConnectionState.done:
                      return Container();
                  }
                }
              })
    ],
      ),
    );
  }
}

