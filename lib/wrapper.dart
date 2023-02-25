// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/backend/local_data.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/consumer/consumerNavbar.dart';
import 'package:zerowaste/frontend/login/login.dart';
import 'package:zerowaste/frontend/manufacturer/manufacturerNavbar.dart';
import 'package:zerowaste/frontend/ngo/ngoNavbar.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String type = '';
  getType() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var uid = FirebaseAuth.instance.currentUser!.uid;
      String res = await DataBaseHelper.instance.getUsersById(uid);
      setState(() {
        type = res;
      });
    }
  }

  @override
  void initState() {
    getType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            if (type == 'Consumer') {
              return ConsumerNavbar();
            } else if (type == 'Manufacturer') {
              return ManufacturerNavbar();
            } else if (type == 'NGO') {
              return NgoNavbar();
            }
            return Loader();
          } else {
            return LoginScreen();
          }
        } else {
          return Loader();
        }
      },
    );
  }
}
