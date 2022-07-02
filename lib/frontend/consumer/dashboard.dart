// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String itemvalue = 'Books';
  String monthvalue = 'January';

  // List of items in our dropdown menu
  var items = [
    'Books',
    'Clothes',
    'Stationary',
    'Hygiene',
    'Toys',
    'Accessories',
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

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
            ChartData(2010, 35),
            ChartData(2011, 28),
            ChartData(2012, 34),
            ChartData(2013, 32),
            ChartData(2014, 40)
        ];
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
                ElevatedButton(onPressed: (){}, child: Text('Go'))
              ],
            ),
            Center(
                child: Container(
                    child: SfCartesianChart(
                        series: <ChartSeries>[
                            // Renders line chart
                            LineSeries<ChartData, int>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                        ]
                    )
                )
            )
          ],
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
