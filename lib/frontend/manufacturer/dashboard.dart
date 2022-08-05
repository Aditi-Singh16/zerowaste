// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String itemvalue = 'Clothes';
  String monthvalue = 'January';
  String cityvalue = 'Silchar';

  // List of items in our dropdown menu
  var items = [
    'Clothes',
    'Stationary',
    'Hygiene',
    'Toys',
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

  var city = ['Mumbai', 'Guwahati', 'Silchar'];

  TextEditingController unitPriceController = TextEditingController();
  TextEditingController taxPercentController = TextEditingController();
  TooltipBehavior _tooltip = TooltipBehavior(enable: true);


  var quantityPred = 0.0;

  Future<void> predData() async {
    final interpreter =
        await Interpreter.fromAsset('model/quantity_prediction.tflite');

    var input = [
      [
        (int.parse(unitPriceController.text)).toDouble(),
        (int.parse(taxPercentController.text)).toDouble(),
        (months.indexOf(monthvalue)).toDouble(),
        (city.indexOf(cityvalue)).toDouble(),
        (items.indexOf(itemvalue)).toDouble()
      ]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);

    print(output[0][0]);

    setState(() {
      quantityPred = output[0][0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [];
    return Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: unitPriceController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Unit Price',
                    ),
                    onChanged: (text) {
                      setState(() {
                        unitPriceController.text = text;
                      });
                    },
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: taxPercentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tax Percent',
                    ),
                    onChanged: (text) {
                      setState(() {
                        taxPercentController.text = text;
                      });
                    },
                  ),
                ),
                Spacer(),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  predData();
                },
                child: Text('Go')),

            Text('Prediction is ${quantityPred.toInt()}'),
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
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          var convertedDateTime = snapshot.data!.docs[i]
                              .data()['timestamp']
                              .toDate();
                          String monthName = DateFormat.MMM()
                              .format(convertedDateTime)
                              .toString();
                          int quantity =
                              snapshot.data!.docs[i].data()['quantity'];
                          chartData.add(ChartData(monthName, quantity));
                        }
                        return Center(
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  tooltipBehavior: _tooltip,
                                  series: <ChartSeries<ChartData, String>>[
                                  // Renders line chart
                                  ColumnSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,

                                    )
                                          
                                ])));

                      case ConnectionState.done:
                        return Container();
                    }
                  }
                }),
          ],
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
