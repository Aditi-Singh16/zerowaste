import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/manufacturer/inputDisposalCategory.dart';
import 'package:zerowaste/frontend/login/profile_page.dart';
import 'package:zerowaste/frontend/manufacturer/dashboard.dart';
import 'package:zerowaste/frontend/manufacturer/ordersTabbar.dart';
import 'package:zerowaste/frontend/manufacturer/productsTabBar.dart';

class ManufacturerNavbar extends StatefulWidget {
  const ManufacturerNavbar({Key? key}) : super(key: key);

  @override
  _ManufacturerNavbarState createState() => _ManufacturerNavbarState();
}

class _ManufacturerNavbarState extends State<ManufacturerNavbar> {
  int pageIndex = 0;

  final pages = [
    const Dashboard(),
    const OrdersTabBar(),
    const ProductsTabBar(),
    InputCategory(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? Icon(
                    CupertinoIcons.graph_circle_fill,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    CupertinoIcons.graph_circle,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? Icon(
                    Icons.task,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    Icons.task_outlined,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? Icon(
                    CupertinoIcons.add_circled_solid,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    CupertinoIcons.add_circled,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            icon: pageIndex == 3
                ? Icon(
                    CupertinoIcons.map_fill,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    CupertinoIcons.map,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 4;
              });
            },
            icon: pageIndex == 4
                ? Icon(
                    Icons.person,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    Icons.person_outline,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  ),
          ),
        ],
      ),
    );
  }
}
