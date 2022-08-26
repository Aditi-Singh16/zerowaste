import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scratcher/widgets.dart';
import 'package:zerowaste/backend/firestore_info.dart';

class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);

  @override
  State<Company> createState() => _Company();
}

class _Company extends State<Company> {
  var totConsumer = 0,
      totalNGO = 0,
      totManu = 0,
      prod_donated = 0,
      resell = 0,
      totUser = 0,
      user = 0;
  int prod_sold = 0;
  double co2 = 0, air = 0, tree = 0;

  getTotalUser() async {
    var res2 = await FirebaseData().TotalUser();
    setState(() {
      totUser = res2;
      //  prod_sold =
      print("hiiiiiiiiiiiiiiii");
      print(res2);
    });
  }

  getTotalConsumer() async {
    var res1 = await FirebaseData().CompanyTotalConsumer();
    setState(() {
      totConsumer = res1;
      //  prod_sold =
      print("hiiiiiiiiiiiiiiii");
      print(res1);
    });
  }

  getTotalManu() async {
    var res1 = await FirebaseData().CompanyTotalManu();
    setState(() {
      totManu = res1;
      //  prod_sold =
      print("hiiiiiiiiiiiiiiii");
      print(totManu);
    });
  }

  getTotalNGO() async {
    var res1 = await FirebaseData().CompanyTotalNGO();
    setState(() {
      totalNGO = res1;
      //  prod_sold =
      print("hiiiiiiiiiiiiiiii");
      print(totalNGO);
    });
  }

  getTotalProds() async {
    var resp = await FirebaseData().TotalProds();
    setState(() {
      prod_sold = resp;
      //  prod_sold =
      // print("hiiiiiiiiiiiiiiii");
      // print(totalNGO);
    });
  }

  getTotalResell() async {
    var resc = await FirebaseData().CompanyConsumerToConsumer();
    setState(() {
      resell = resc;
      //  prod_sold =
      // print("hiiiiiiiiiiiiiiii");
      // print(totalNGO);
    });
  }

  getAir() async {
    var resa = await FirebaseData().CompanyESVAir();
    setState(() {
      air = resa;
      //  prod_sold =
      // print("hiiiiiiiiiiiiiiii");
      // print(totalNGO);
    });
  }

  getTree() async {
    var restr = await FirebaseData().CompanyESVTree();
    setState(() {
      tree = restr;
      //  prod_sold =
      // print("hiiiiiiiiiiiiiiii");
      // print(totalNGO);
    });
  }

  getCo2() async {
    double resc = await FirebaseData().CompanyESVCo2();
    setState(() {
      co2 = resc;
      //  prod_sold =
      // print("hiiiiiiiiiiiiiiii");
      // print(totalNGO);
    });
  }

  @override
  void initState() {
    getTotalConsumer();
    getTotalManu();
    getTotalNGO();
    getTotalProds();
    getTotalResell();
    getAir();
    getTree();
    getCo2();
    getTotalUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Overall Analytics")),
        body: Center(
          child: ListView(children: [
            SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
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
                              (totConsumer + totManu + totalNGO).toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Users ",
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
                              totConsumer.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Consumers",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Row(
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
                              totManu.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Manufacturer",
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
                              totalNGO.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total NGO Connected",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Row(
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
                              prod_sold.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Products Sold",
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
                              resell.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Resell Products",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Row(
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
                              air.toString().substring(0, 4),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Environment Saving Values: Air",
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
                              co2.toString().substring(0, 4),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Environment Saving Values: Co2",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Row(
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
                              tree.toString().substring(0, 4),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Environment Saving Values: Tree",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ],
            )
          ]),
        ));
  }
}
