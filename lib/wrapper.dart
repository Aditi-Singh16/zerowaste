import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumerNavbar.dart';
import 'package:zerowaste/frontend/login/login.dart';
import 'package:zerowaste/frontend/manufacturerNavbar.dart';
import 'package:zerowaste/frontend/ngoNavbar.dart';
import 'package:zerowaste/frontend/login/profile_page.dart';
import 'backend/firestore_info.dart';

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
      var data = FirebaseFirestore.instance.collection("Users").doc(uid).get();
      Map<String, dynamic> userData = data as Map<String, dynamic>;
      setState(() {
        type = userData['type'];
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
            return ProfilePage();
          } else {
            return LoginScreen();
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
