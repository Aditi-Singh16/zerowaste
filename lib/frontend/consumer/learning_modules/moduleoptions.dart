import 'package:flutter/material.dart';
import 'learningMod.dart';

class LearningModules extends StatefulWidget {
  const LearningModules({Key? key}) : super(key: key);

  @override
  State<LearningModules> createState() => _LearningModulesState();
}

class _LearningModulesState extends State<LearningModules> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255)
          ])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff001427),
          leading: Image.asset(
            'assets/images/logo1.png',
            fit: BoxFit.contain,
          ),
          title: Text("For D.I.Y Enthusiasts"),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Learn to Recycle",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "All set to Recycle and save the Planet !",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePager(type: 2),
                          ),
                        );
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 64,
                                height: 64,
                                child: Image.network(
                                    "https://img.icons8.com/bubbles/100/000000/t-shirt.png")),
                            Container(
                              child: Text(
                                "Clothing",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePager(type: 3),
                          ),
                        );
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 64,
                                height: 64,
                                child: Image.network(
                                    "https://img.icons8.com/external-smashingstocks-basic-outline-smashing-stocks/100/000000/external-no-plastic-world-environment-day-smashingstocks-basic-outline-smashing-stocks.png")),
                            Container(
                              child: Text(
                                "Plastic",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePager(type: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 64,
                                  height: 64,
                                  child: Image.network(
                                      'https://img.icons8.com/bubbles/100/000000/apple-watch.png')),
                              Container(
                                child: Text(
                                  "Electronics",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePager(type: 4),
                            ),
                          );
                        },
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 64,
                                  height: 64,
                                  child: Image.network(
                                      "https://img.icons8.com/bubbles/100/000000/book-shelf.png")),
                              Container(
                                child: Text(
                                  "Books",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePager(type: 5),
                          ),
                        );
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 64,
                                height: 64,
                                child: Image.network(
                                    "https://img.icons8.com/bubbles/100/000000/bag-front-view.png")),
                            Container(
                              child: Text(
                                "Bags",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePager(type: 0),
                            ),
                          );
                        },
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 64,
                                  height: 64,
                                  child: Image.network(
                                      "https://img.icons8.com/external-flaticons-lineal-color-flat-icons/100/000000/external-stationery-home-improvement-flaticons-lineal-color-flat-icons.png")),
                              Container(
                                child: Text(
                                  "Stationery",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
