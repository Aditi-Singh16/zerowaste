import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ManuFacture extends StatefulWidget {
  final String prodctId;
  const ManuFacture({
    Key? key,
    required this.prodctId,
  }) : super(key: key);

  @override
  State<ManuFacture> createState() => _ManuFactureState();
}

class _ManuFactureState extends State<ManuFacture> {
  num? returns;
  num? sold;
  getDetails() async {
    var val1 = await FirebaseData().getProductReturnCount();
    var val2 = await FirebaseData().getProductSoldCount();
    setState(() {
      returns = val1;
      sold = val2;
    });
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

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

  Future<dynamic> getManufactureProductCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .where('ProductId', isEqualTo: widget.prodctId)
        .get();

    return res;
  }

  Future<void> predData() async {
    actualChartData = [];
    var res = await getManufactureProductCount();
    res.docs.forEach((element) {
      totalSoldCount = totalSoldCount.toInt() + element['Quantity'].toInt();
      var date = element['Date'];
      var start = date.indexOf('/');
      var end = date.lastIndexOf('/');
      var month = date.substring(start + 1, end);
      for (int i = 0; i < 8; i++) {
        if (i + 1 == int.parse(month)) {
          actualChartData
              .add(ChartData(months[i + 1], element['Quantity'].toInt()));
        }
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Analytics'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Card(
                    child: Container(
                  color: const Color(0xffC87FFC),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          sold.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Sales",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
                Card(
                    child: Container(
                  color: const Color(0xffFE9E87),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          returns.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Returns",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff3472c0), //<-- SEE HERE
                      ),
                      child: DropdownButton(
                        underline: Container(),
                        dropdownColor: const Color(0xff3472c0),
                        value: monthvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconEnabledColor: Colors.white,
                        isExpanded: true,
                        items: months.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                              child: Text(items,
                                  style: const TextStyle(
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
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff3472c0)),
                      ),
                      onPressed: () {
                        predData();
                      },
                      child: const Text('Go')),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 22.0),
              child: Text('Sold Product Analytics',
                  style: TextStyle(fontSize: 25)),
            ),
            Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        tooltipBehavior: _tooltipPred,
                        series: <ChartSeries>[
                          // Renders line chart
                          LineSeries<ChartData, String>(
                            dataSource: actualChartData,
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
