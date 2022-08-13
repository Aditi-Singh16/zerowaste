import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Orders.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/consumer/consumer_tabbar.dart';
import 'package:zerowaste/frontend/consumer/learning_modules/moduleoptions.dart';
import 'package:zerowaste/frontend/login/profile_page.dart';

class ConsumerNavbar extends StatefulWidget {
  const ConsumerNavbar({Key? key}) : super(key: key);

  @override
  _ConsumerNavbarState createState() => _ConsumerNavbarState();
}

class _ConsumerNavbarState extends State<ConsumerNavbar> {
  int pageIndex = 0;

  final pages = [
    UserHome(),
    const MyApp(),
    ConsumerTabBar(),
    YourOrders(),
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
                    Icons.home,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    Icons.home_outlined,
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
                    CupertinoIcons.leaf_arrow_circlepath,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    CupertinoIcons.leaf_arrow_circlepath,
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
                    Icons.live_help_rounded,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    Icons.live_help_outlined,
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
                    Icons.history,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 24,
                  )
                : Icon(
                    Icons.history,
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
