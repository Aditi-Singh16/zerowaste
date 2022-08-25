import 'package:flutter/material.dart';

class ManufactureAnalytics extends StatefulWidget {
  ManufactureAnalytics({Key? key}) : super(key: key);

  @override
  State<ManufactureAnalytics> createState() => _ManufactureAnalyticsState();
}

class _ManufactureAnalyticsState extends State<ManufactureAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Analytics")),
        body: ListView(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Card(
                      child: Container(
                    color: Color(0xff3698F3),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "1000",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Sales",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 20),
                  Card(
                      child: Container(
                    color: Color(0xffE05A71),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "500",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Customers",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              Column(
                children: [
                  Card(
                      child: Container(
                    color: Color(0xffC87FFC),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "1000",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Returns",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 20),
                  Card(
                      child: Container(
                    color: Color(0xffFE9E87),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "500",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Donations",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ],
          )
        ]));
  }
}
