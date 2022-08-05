import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/consumer_tabbar.dart';
import 'package:zerowaste/frontend/consumer/dashboard.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/frontend/inputDisposalCategory.dart';
import 'package:zerowaste/frontend/manufacturer/addProduct.dart';
import 'package:zerowaste/frontend/wasteDisposal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF2F6FD),
          appBarTheme: AppBarTheme(backgroundColor: Color(0xff001427))),
      home: inputCategory(),
    );
  }
}
