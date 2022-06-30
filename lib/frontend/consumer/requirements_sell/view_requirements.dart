// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ViewRequirements extends StatefulWidget {
  const ViewRequirements({Key? key}) : super(key: key);

  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
  List<bool> _selections = List.generate(3, (_) => false);

  String userType = "NGO";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        ToggleButtons(
          children: <Widget>[
            const Icon(Icons.format_bold),
            const Icon(Icons.format_italic),
            const Icon(Icons.format_underlined),
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
        userType=="NGO" ?
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('requirements')
              .where("type",isEqualTo: "NGO")
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
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Column(
                      children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.builder(
                        itemCount:
                            snapshot.data['jobs_applied'].length,
                        itemBuilder: (context, i) {
                          return Column(children: [
                                Text('${snapshot.data['product_name']}'),
                                const Text('Quantity: '),
                                Text('${snapshot.data['quantity']}'),
                                ElevatedButton(onPressed: (){}, child: const Text('I got u!'))
                              ],);
                        })
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,)
                      ]
                    ),
                  );
                case ConnectionState.done:
                  return Container();
              }
            }
          }
        )
        :
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('requirements')
              .where("type",isEqualTo: "Consumer")
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
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Column(
                      children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.builder(
                        itemCount:
                            snapshot.data.length,
                        itemBuilder: (context, i) {
                          return Column(children: [
                                Text('${snapshot.data['product_name']}'),
                                const Text('Quantity: '),
                                Text('${snapshot.data['quantity']}'),
                                ElevatedButton(onPressed: (){}, child: const Text('I got u!'))
                              ],);
                        })
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,)
                      ]
                    ),
                  );
                case ConnectionState.done:
                  return Container();
              }
            }
          }
        )
      ],
    ));
  }
}
