// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zerowaste/frontend/login/login.dart';
import 'package:zerowaste/frontend/manufacturer/Analytics.dart';
import 'package:zerowaste/wrapper.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Center(
          child: SpinKitChasingDots(
        color: Colors.blue,
        size: 50.0,
      ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF2F6FD),
          appBarTheme: AppBarTheme(backgroundColor: Color(0xff001427))),
      home: ManufactureAnalytics(),
    );
  }
}
