import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ConsumerAnalytics extends StatefulWidget {
  const ConsumerAnalytics({Key? key}) : super(key: key);

  @override
  State<ConsumerAnalytics> createState() => _ConsumerAnalyticsState();
}

class _ConsumerAnalyticsState extends State<ConsumerAnalytics> {
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

  TooltipBehavior _tooltipAct = TooltipBehavior(enable: true);
  TooltipBehavior _tooltipPred = TooltipBehavior(enable: true);

  List<ChartData> actualChartData = [];
  List<ChartData> actualChartData1 = [];

  Future<void> predData() async {
    actualChartData = [];
    actualChartData1 = [];
    var res = await getManufactureSoldCount();
    var res1 = await getManufacureReturnCount();
    print(res);
    res.docs.forEach((element) {
      totalSoldCount = totalSoldCount.toInt() + element['Quantity'];
      var date = element['Date'];
      var start = date.indexOf('/');
      var end = date.lastIndexOf('/');
      var month = date.substring(start + 1, end);
      for (int i = 0; i < 8; i++) {
        if (i + 1 == int.parse(month)) {
          actualChartData.add(ChartData(months[i], element['Quantity']));
        }
      }
    });

    res1.docs.forEach((element) {
      totalReturnCount = totalReturnCount.toInt() + element['Quantity'].toInt();
      var date = element['Date'];
      var start = date.indexOf('/');
      var end = date.lastIndexOf('/');
      var month = date.substring(start + 1, end);
      for (int i = 0; i < 8; i++) {
        if (i + 1 == int.parse(month)) {
          actualChartData1.add(ChartData(months[i], element['Quantity']));
        }
      }
    });

    setState(() {});

    print(actualChartData1);
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff3472c0), //<-- SEE HERE
                      ),
                      child: DropdownButton(
                        underline: Container(),
                        dropdownColor: Color(0xff3472c0),
                        value: monthvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconEnabledColor: Colors.white,
                        isExpanded: true,
                        items: months.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                              child: Text(items,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            monthvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff3472c0)),
                      ),
                      onPressed: () {
                        predData();
                      },
                      child: Text('Go')),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsetsDirectional.all(40),
              width: MediaQuery.of(context).size.width * 0.87,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 113, 199, 116),
                    Color.fromARGB(255, 86, 153, 207)
                  ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
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
                  Text('Return Efficiency of the consumer',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  Row(
                    children: [
                      Text('Return Rate = ',
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                      Spacer(),
                      Text('${totalReturnCount / totalSoldCount}',
                          style: TextStyle(fontSize: 18, color: Colors.black))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('Sold Product Analytics',
                  style: TextStyle(fontSize: 25)),
            ),
            Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        tooltipBehavior: _tooltipPred,
                        series: <ChartSeries<ChartData, String>>[
                          // Renders line chart
                          ColumnSeries<ChartData, String>(
                            dataSource: actualChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          )
                        ]))),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('Returned product Analytics',
                  style: TextStyle(fontSize: 25)),
            ),
            Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        tooltipBehavior: _tooltipAct,
                        series: <ChartSeries<ChartData, String>>[
                          // Renders line chart
                          ColumnSeries<ChartData, String>(
                            dataSource: actualChartData1,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          )
                        ]))),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  String x;
  int y;
}

Future<dynamic> getManufactureSoldCount() async {
  var uid = await HelperFunctions().readUserIdPref();
  var res = await FirebaseFirestore.instance
      .collectionGroup('Orders')
      .where('manufacturerId', isEqualTo: uid)
      .get();
  print('hii');
  print(uid);
  print(res.docs.length);
  print(res.docs);

  return res;
}

Future<dynamic> getManufacureReturnCount() async {
  var uid = await HelperFunctions().readUserIdPref();
  var res = await FirebaseFirestore.instance
      .collectionGroup('Orders')
      .where('manufacturerId', isEqualTo: uid)
      .where('is_return', isEqualTo: true)
      .get();

  return res;
}
