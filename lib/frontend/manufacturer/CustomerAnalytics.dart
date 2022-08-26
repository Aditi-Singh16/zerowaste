import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerAnalytics extends StatefulWidget {
  CustomerAnalytics({Key? key}) : super(key: key);

  @override
  State<CustomerAnalytics> createState() => _CustomerAnalyticsState();
}

class _CustomerAnalyticsState extends State<CustomerAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(builder: (context, snapshot) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Customers return rate analysis"),
            SizedBox(height: 40),
            Column(
              children: [
                Card(
                    child: Container(
                  color: Color(0xff3698F3),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "20",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Less than 25%",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 20),
                Card(
                    child: Container(
                  color: Color(0xffC87FFC),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "40",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Between 25% - 75%",
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
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "40",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "More than 75%",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ],
        ),
      );
    }));
  }
}
