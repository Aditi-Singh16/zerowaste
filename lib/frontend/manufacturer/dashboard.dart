// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:intl/intl.dart';
import 'package:zerowaste/backend/firestore_info.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String itemvalue = 'Cotton Clothes';
  String monthvalue = 'January';
  String cityvalue = 'Silchar';

  // List of items in our dropdown menu
  var items = [
    'Cotton Clothes',
    'Silk Clothes',
    'Hygiene',
    'Books',
    'Bags',
    'Electronics'
  ];

  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  var monthsPred = [];
  var monthsAct = [];

  var city = ['Mumbai', 'Guwahati', 'Silchar'];

  Random rnd = new Random();
  var unitPrice = 10;
  var taxPrice = 5;

  TooltipBehavior _tooltipAct = TooltipBehavior(enable: true);
  TooltipBehavior _tooltipPred = TooltipBehavior(enable: true);
  List<ChartData> predictionChartData = [];
  List<ChartData> actualChartData = [];
  var quantAvail = 0;

  Future<void> predData() async {
    final interpreter =
        await Interpreter.fromAsset('model/quantity_prediction.tflite');
    var monthSlice = [];
    unitPrice = 15 + rnd.nextInt(10000 - 15);
    taxPrice = 1 + rnd.nextInt(20 - 1);
    List res = await FirebaseData().getProducts(itemvalue);
    res.forEach((element) {
      var convertedDateTime = element.data()['timestamp'].toDate();
      String monthName = DateFormat.LLLL().format(convertedDateTime).toString();
      for (int i = 0; i < monthsAct.length; i++) {
        if (monthsAct[i] == monthName) {
          actualChartData.add(ChartData(monthName, element.data()['quantity']));
        } else {
          actualChartData.add(ChartData(monthsAct[i], 0));
        }
      }
      //setState(() {});
    });

    var monthval = monthsPred.indexOf(monthvalue);
    var currMonth = int.parse(DateFormat.M().format(DateTime.now()));
    monthSlice = monthsPred.sublist(currMonth - 1, monthval + 1);
    for (int i = 0; i < monthSlice.length; i++) {
      var input = [
        [
          (unitPrice).toDouble(),
          (taxPrice).toDouble(),
          (months.indexOf(monthSlice[i])).toDouble(),
          (city.indexOf(cityvalue)).toDouble(),
          (items.indexOf(itemvalue)).toDouble()
        ]
      ];
      var output = List.filled(1, 0).reshape([1, 1]);
      interpreter.run(input, output);
      predictionChartData.add(ChartData(monthSlice[i], output[0][0].toInt()));
      setState(() {});
    }
  }

  @override
  void initState() {
    var start = int.parse(DateFormat.M().format(DateTime.now()));
    monthvalue = months[start - 1];
    monthsAct = months.sublist(0, start - 1);
    monthsPred = months;
    months = months.sublist(start - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                DropdownButton(
                  value: itemvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      itemvalue = newValue!;
                    });
                  },
                ),
                Spacer(),
                DropdownButton(
                  value: monthvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: months.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      monthvalue = newValue!;
                      monthsAct =
                          monthsPred.sublist(0, monthsPred.indexOf(monthvalue));
                    });
                  },
                ),
                Spacer(),
                DropdownButton(
                  value: cityvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: city.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      cityvalue = newValue!;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    predData();
                  },
                  child: Text('Go')),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child:
                  Text('Quantity Prediction', style: TextStyle(fontSize: 25)),
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
                            dataSource: predictionChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          )
                        ]))),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('My Inventory', style: TextStyle(fontSize: 25)),
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
                          LineSeries<ChartData, String>(
                            dataSource: actualChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          )
                        ]))),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('My Products', style: TextStyle(fontSize: 25)),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where("manufacturerId", isEqualTo: "unfoWBpH8AidhiSmwx44")
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
                        return Center(
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, i) {
                                      return Card(
                                        child: ListTile(
                                          leading: SvgPicture.asset(
                                              'assets/icons/${snapshot.data!.docs[i]['categories']}.svg',
                                              width: 70.0,
                                              height: 70.0),
                                          title: Text(
                                              '${snapshot.data!.docs[i]['name']}'),
                                          subtitle: Text(
                                              'Quantity: ${snapshot.data!.docs[i]['quantity']}'),
                                        ),
                                        elevation: 8,
                                        margin: EdgeInsets.all(10),
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      );
                                    })));

                      case ConnectionState.done:
                        return Container();
                    }
                  }
                }),
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