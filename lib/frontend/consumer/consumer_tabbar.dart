// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/requirements_sell/add_requirements.dart';
import 'package:zerowaste/frontend/consumer/view_requirements.dart';

class ConsumerTabBar extends StatelessWidget {
  const ConsumerTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: const Color(0xff001427),
            leading: Image.asset(
              'assets/images/logo1.png',
              fit: BoxFit.contain,
            ),
            title: Text("Requirements"),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Add",
                ),
                Tab(text: "View"),
              ],
            ),
          ),
          body: TabBarView(
            children: [AddRequirement(), ViewRequirements()],
          ),
        ),
      ),
    );
  }
}
