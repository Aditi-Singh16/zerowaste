// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';
import 'package:zerowaste/frontend/manufacturer/Analytics.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  num? sales;
  num? customers;
  num? returns;
  num? donations;
  List<int> gridData = [];
  List<String> gridLabel = [
    "Total Sales",
    "Total Returns",
    "Total Customers",
    "Total Donations"
  ];
  List<List<Color>> gridColor = [
    [Colors.blue[100]!, Colors.blue],
    [Colors.red[100]!, Colors.red],
    [Colors.green[100]!, Colors.green],
    [Colors.yellow[100]!, Colors.yellow]
  ];
  var userId;

  getManufacturerAnalytics() async {
    var uid = await _helperFunctions.readUserIdPref();
    var sales = await FirebaseData().getManufactureSoldCount();
    var customers = await FirebaseData().getManufactureCustomerCount();
    var returns = await FirebaseData().getManufacureReturnCount();
    var donations = await FirebaseData().getManufactureDonationCount();
    setState(() {
      userId = uid;
      sales = sales;
      customers = customers;
      returns = returns;
      donations = donations;
      gridData = [
        sales.toInt(),
        returns.toInt(),
        customers.toInt(),
        donations.toInt()
      ];
    });
  }

  HelperFunctions _helperFunctions = HelperFunctions();
  String itemvalue = 'Cotton Clothes';
  String monthvalue = 'January';
  String cityvalue = 'Silchar';
  String yearvalue = DateTime.now().year.toString();

  // List of items in our dropdown menu
  List<List<String>> dropdownValues = [
    [
      'Cotton Clothes',
      'Silk Clothes',
      'Nylon Clothes',
      'Books',
      'Bags',
      'Electronics'
    ],
    [
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
    ],
    ['Mumbai', 'Guwahati', 'Silchar']
  ];
  var monthsPred = [];
  var monthsAct = [];

  Random rnd = new Random();
  var unitPrice = 10;
  var taxPrice = 5;

  TooltipBehavior _tooltipAct = TooltipBehavior(enable: true);
  TooltipBehavior _tooltipPred = TooltipBehavior(enable: true);

  List<ChartData> predictionChartData = [];
  List<ChartData> actualChartData = [];
  Map<int, List<ChartData>> previousChartData = {};
  List<String> yeardorpdownValues = [DateTime.now().year.toString()];
  int prevYear = 0;
  var quantAvail = 0;

  Future<void> predData() async {
    actualChartData = [];
    predictionChartData = [];
    previousChartData = {};

    final interpreter =
        await Interpreter.fromAsset('model/quantity_prediction.tflite');
    var monthSlice = [];
    unitPrice = 15 + rnd.nextInt(10000 - 15);
    taxPrice = 1 + rnd.nextInt(20 - 1);
    List res = await FirebaseData().getProducts(itemvalue);
    res.forEach((element) {
      var convertedDateTime = element.data()['timestamp'].toDate();
      String monthName = DateFormat.LLLL().format(convertedDateTime).toString();
      int currentYear = 2023;
      int year = DateTime.parse(convertedDateTime.toString()).year;
      if (currentYear - year > 0) {
        if (!yeardorpdownValues.contains(monthName)) {
          yeardorpdownValues.add(year.toString());
        }
        previousChartData.putIfAbsent(
            year, () => [ChartData(monthName, element.data()['quantity'])]);
      }
      for (int i = 0; i < monthsAct.length; i++) {
        if (monthsAct[i] == monthName) {
          actualChartData.add(ChartData(monthName, element.data()['quantity']));
        } else {
          actualChartData.add(ChartData(monthsAct[i], 0));
        }
      }
    });

    var monthval = monthsPred.indexOf(monthvalue);
    var currMonth = int.parse(DateFormat.M().format(DateTime.now()));
    monthSlice = monthsPred.sublist(currMonth - 1, monthval + 1);
    for (int i = 0; i < monthSlice.length; i++) {
      var input = [
        [
          (unitPrice).toDouble(),
          (taxPrice).toDouble(),
          (dropdownValues[1].indexOf(monthSlice[i])).toDouble(),
          (dropdownValues[2].indexOf(cityvalue)).toDouble(),
          (dropdownValues[0].indexOf(itemvalue)).toDouble()
        ]
      ];
      var output = List.filled(1, 0).reshape([1, 1]);
      interpreter.run(input, output);
      predictionChartData.add(ChartData(monthSlice[i], output[0][0].toInt()));
      setState(() {});
      print(previousChartData[2022]);
      actualChartData.forEach((element) {
        print(element.x);
      });
    }
  }

  @override
  void initState() {
    getManufacturerAnalytics();
    var start = int.parse(DateFormat.M().format(DateTime.now()));
    monthvalue = dropdownValues[1][start - 1];
    monthsAct = dropdownValues[1].sublist(0, start - 1);
    monthsPred = dropdownValues[1];
    dropdownValues[1] = dropdownValues[1].sublist(start - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff001427),
        leading: Image.asset(
          'assets/images/logo1.png',
          fit: BoxFit.contain,
        ),
        title: Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: (1 / .8),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: List.generate(4, (index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: gridColor[index])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              gridData[index].toString(),
                              style: TextStyle(color: AppColor.text),
                            ),
                            SizedBox(height: 10),
                            Text(
                              gridLabel[index],
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                thickness: 5,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: dropdownValues.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 20,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: AppColor.dropdown,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton(
                        underline: Container(),
                        value: index == 0
                            ? itemvalue
                            : index == 1
                                ? monthvalue
                                : cityvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconEnabledColor: Colors.white,
                        items: dropdownValues[index].map((String items) {
                          return DropdownMenuItem(
                            alignment: Alignment.center,
                            value: items,
                            child: Text(items,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          );
                        }).toList(),
                        dropdownColor: Color(0xff3472c0),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (index == 0) {
                              itemvalue = newValue!;
                            } else if (index == 1) {
                              monthvalue = newValue!;
                            } else {
                              cityvalue = newValue!;
                            }
                          });
                        },
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff3472c0)),
                  ),
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
            actualChartData.isNotEmpty
                ? Row(
                    children: [
                      yeardorpdownValues.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Text('My Inventory',
                                  style: TextStyle(fontSize: 25)),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Text('My Inventory',
                                  style: TextStyle(fontSize: 25)),
                            ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 22.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: AppColor.dropdown,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            underline: Container(),
                            value: yearvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconEnabledColor: Colors.white,
                            items: yeardorpdownValues.map((String years) {
                              return DropdownMenuItem(
                                alignment: Alignment.center,
                                value: years,
                                child: Text(years,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              );
                            }).toList(),
                            dropdownColor: Color(0xff3472c0),
                            onChanged: (String? newValue) {
                              print(newValue);
                              yearvalue = newValue!;

                              setState(() {
                                prevYear = int.parse(newValue!);
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            actualChartData.isNotEmpty &&
                    yearvalue == DateTime.now().year.toString()
                ? Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            tooltipBehavior: _tooltipAct,
                            series: <ChartSeries<ChartData, String>>[
                              // Renders line chart
                              ColumnSeries<ChartData, String>(
                                dataSource: actualChartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                              )
                            ])))
                : prevYear != 0
                    ? Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                tooltipBehavior: _tooltipAct,
                                series: <ChartSeries<ChartData, String>>[
                                  // Renders line chart
                                  ColumnSeries<ChartData, String>(
                                    dataSource: previousChartData[prevYear]!,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                  )
                                ])))
                    : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('My Products', style: TextStyle(fontSize: 25)),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where("manufacturerId", isEqualTo: userId)
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
                        return Center(
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ManuFacture(
                                                    context: context,
                                                    prodctId: snapshot.data!
                                                        .docs[i]['productId']));
                                      },
                                      child: Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Image(
                                                image: NetworkImage(snapshot
                                                    .data!.docs[i]['image']),
                                              )),
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
                                      ),
                                    );
                                  })),
                        );

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
