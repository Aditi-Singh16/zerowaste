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

  // getTotalResell() async {
  //   var resc = await FirebaseData().CompanyConsumerToConsumer();
  //   setState(() {
  //     resell = resc;
  //     //  prod_sold =
  //     // print("hiiiiiiiiiiiiiiii");
  //     // print(totalNGO);
  //   });
  // }

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
    //getTotalResell();
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
            height: 150,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              children: [
                InkWell(
                  child: Card(
                      child: Container(
                    color: Color(0xff3698F3),
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: MediaQuery.of(context).size.height / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Users:-  " +
                              (totConsumer + totalNGO + totManu).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  )),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Scaffold(
                                    body: Center(
                                  child: Column(children: [
                                    SizedBox(height: 240),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Consumers:-  " +
                                                totConsumer.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    SizedBox(height: 20),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Manufacturers:-  " +
                                                totManu.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    SizedBox(height: 20),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total NGO:-  " +
                                                totalNGO.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ]),
                                ))));
                  },
                ),
                ///////
                InkWell(
                  child: Card(
                      child: Container(
                    color: Color(0xff3698F3),
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: MediaQuery.of(context).size.height / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Transactions:-  " +
                              (prod_sold + resell).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  )),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Scaffold(
                                    body: Center(
                                  child: Column(children: [
                                    SizedBox(height: 240),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Products Sold:-  " +
                                                prod_sold.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    SizedBox(height: 20),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Resell:-  " +
                                                resell.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ]),
                                ))));
                  },
                ),

                ///
                ///
                InkWell(
                  child: Card(
                      child: Container(
                    color: Color(0xff3698F3),
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: MediaQuery.of(context).size.height / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Environment Saving Values",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Scaffold(
                                    body: Center(
                                  child: Column(children: [
                                    SizedBox(height: 240),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ESV Air:-  " +
                                                air.toString() +
                                                "aqi",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    SizedBox(height: 20),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ESV Co2:-  " +
                                                co2.toString() +
                                                "ppm",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    SizedBox(height: 20),
                                    Card(
                                        child: Container(
                                      color: Color(0xff3698F3),
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ESV Soil:-  " + tree.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ]),
                                ))));
                  },
                ),
              ],
            ),
            //??/////////////////////////
          ]),
        ])));
  }
}
