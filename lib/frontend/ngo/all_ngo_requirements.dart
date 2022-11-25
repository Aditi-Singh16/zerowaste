// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';
import 'package:zerowaste/frontend/Helpers/style.dart';

class AllRequirements extends StatefulWidget {
  String uid;
  AllRequirements({required this.uid, Key? key}) : super(key: key);

  @override
  State<AllRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<AllRequirements> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requirements')
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Loader();
              case ConnectionState.waiting:
                return const Loader();
              case ConnectionState.active:
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return !doc.data()!.containsKey('requirement_satisfy')
                          ? Container()
                          : Column(
                              children: [
                                Text(
                                  'Completed Requirements',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.check_circle,
                                        size: 40, color: AppColor.appcolor3),
                                    title: Text('${doc['email']}'),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('In Stock: ${doc['quantity']}'),
                                        Text('Product: ${doc['product_name']}')
                                      ],
                                    ),
                                    trailing: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColor.appcolor1),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            var acceptedUid =
                                                doc['requirement_satisfy']
                                                    [index]['uid'];
                                            Map<String, dynamic> acceptedMap = {
                                              "category": doc['category'],
                                              "quantity":
                                                  doc['quantity'].toString(),
                                              "email":
                                                  doc['requirement_satisfy']
                                                      [index]['email']
                                            };
                                            FirebaseData().addCouponToDonors(
                                                acceptedUid,
                                                acceptedMap,
                                                doc.id,
                                                widget.uid);
                                          });
                                        },
                                        child: Text(
                                          "Order",
                                          style: AppStyle.bodyText.copyWith(
                                              color: Colors.white,
                                              fontSize: 16),
                                        )),
                                  ),
                                  elevation: 8,
                                  margin: EdgeInsets.all(10),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ],
                            );
                    });
              case ConnectionState.done:
                return Container();
            }
          }
        });
  }
}
