import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class NgoAnalytics extends StatefulWidget {
  const NgoAnalytics({Key? key}) : super(key: key);

  @override
  State<NgoAnalytics> createState() => _NgoAnalyticsState();
}

class _NgoAnalyticsState extends State<NgoAnalytics> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String monthvalue = 'January';
  num totalReturnCount = 0;
  num totalSoldCount = 0;

  // List of items in our dropdown menu

  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August'
  ];
  int count = 0;
  TooltipBehavior _tooltipAct = TooltipBehavior(enable: true);
  TooltipBehavior _tooltipPred = TooltipBehavior(enable: true);

  // setState(() {});
  Future<void> fetch() async {
    var email = await HelperFunctions().readEmailPref();
    print(email);
    var res = await FirebaseFirestore.instance
        .collection('Users')
        .where("accepted_requests")
        .get();

    res.docs.forEach((element) {
      element['accepted_requests'].forEach((ele) {
        if (ele['email'] == email) {
          setState(() {
            count = count + 1;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Analytics'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('Donated Product Analytics',
                  style: TextStyle(fontSize: 25)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('Total number of donors=' + '$count',
                  style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }

// class ChartData {
//   ChartData(this.x, this.y);
//   String x;
//   int y;
// }

}
