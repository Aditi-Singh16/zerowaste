// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
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
  getManufacturerAnalytics() async {
    var sales = await FirebaseData().getManufactureSoldCount();
    var customers = await FirebaseData().getManufactureCustomerCount();
    var returns = await FirebaseData().getManufacureReturnCount();
    var donations = await FirebaseData().getManufactureDonationCount();
    setState(() {
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

  // List of items in our dropdown menu
  var items = [
    'Cotton Clothes',
    'Silk Clothes',
    'Nylon Clothes',
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
    actualChartData = [];
    predictionChartData = [];

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
    getManufacturerAnalytics();
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
      appBar:
          AppBar(title: Text('Dashboard'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
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
                      //elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
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
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              gridLabel[index],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            ),
            Divider(
              thickness: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.37,
                    height: MediaQuery.of(context).size.height * 0.067,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff3472c0), //<-- SEE HERE
                      ),
                      child: DropdownButton(
                        underline: Container(),
                        value: itemvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconEnabledColor: Colors.white,
                        items: items.map((String items) {
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
                            itemvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Spacer(),
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
                            monthsAct = monthsPred.sublist(
                                0, monthsPred.indexOf(monthvalue));
                          });
                        },
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.26,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff3472c0), //<-- SEE HERE
                      ),
                      child: DropdownButton(
                        underline: Container(),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Color(0xff3472c0),
                        isExpanded: true,
                        value: cityvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: city.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                                child: Text(items,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            cityvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
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
                ? Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Text('My Inventory', style: TextStyle(fontSize: 25)),
                  )
                : Container(),
            actualChartData.isNotEmpty
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
                : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text('My Products', style: TextStyle(fontSize: 25)),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where("manufacturerId",
                        isEqualTo: _helperFunctions.readUserIdPref())
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
