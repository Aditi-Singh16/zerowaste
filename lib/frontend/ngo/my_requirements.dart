import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';

class MyRequirements extends StatefulWidget {
  String uid;
  MyRequirements({required this.uid, Key? key}) : super(key: key);

  @override
  State<MyRequirements> createState() => _MyRequirementsState();
}

class _MyRequirementsState extends State<MyRequirements> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('requirements')
              .where("uid", isEqualTo: widget.uid)
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
                  return Loader();

                case ConnectionState.active:
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.plagiarism_rounded,
                                size: 40, color: Colors.redAccent),
                            title: Text(
                                '${snapshot.data!.docs[i]['product_name']}'),
                            subtitle: Text(
                                'Quantity: ${snapshot.data!.docs[i]['quantity']}'),
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
          }),
    );
  }
}
