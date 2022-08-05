import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/login/profile_page.dart';
import 'package:zerowaste/frontend/manufacturer/dashboard.dart';

class ManufacturerNavbar extends StatefulWidget {
  const ManufacturerNavbar({Key? key}) : super(key: key);

  @override
  _ManufacturerNavbarState createState() => _ManufacturerNavbarState();
}

class _ManufacturerNavbarState extends State<ManufacturerNavbar> {
  int pageIndex = 0;

  final pages = [
    Dashboard(),
    ProfilePage(),
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
                    Icons.home,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    Icons.home_outlined,
                    color: Colors.white,
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
                    CupertinoIcons.tickets_fill,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    CupertinoIcons.tickets,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height / 24,
                  ),
          ),
          // IconButton(
          //   enableFeedback: false,
          //   onPressed: () {
          //     setState(() {
          //       pageIndex = 2;
          //     });
          //   },
          //   icon: pageIndex == 2
          //       ? Icon(
          //           Icons.person,
          //           color: Colors.white,
          //           size: MediaQuery.of(context).size.height / 24,
          //         )
          //       : Icon(
          //           Icons.person_outline,
          //           color: Colors.white,
          //           size: MediaQuery.of(context).size.height / 24,
          //         ),
          // ),
        ],
      ),
    );
  }
}
