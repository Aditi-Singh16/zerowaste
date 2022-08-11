import 'package:flutter/material.dart';
import 'learningMod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 231, 242, 196)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
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
                        builder: (context) => MyHomePager(title: "", type: 2),
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                        builder: (context) => MyHomePager(title: "", type: 3),
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                          builder: (context) => MyHomePager(title: "", type: 1),
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                          builder: (context) => MyHomePager(title: "", type: 4),
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                        builder: (context) => MyHomePager(title: "", type: 5),
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                          builder: (context) => MyHomePager(title: "", type: 0),
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
