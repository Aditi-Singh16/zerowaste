import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/manufacturer/Orders.dart';
import 'package:zerowaste/frontend/manufacturer/returns.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            title: Text("Orders and Returns"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Orders",
                ),
                Tab(text: "Returns"),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [ManuFactureOrders(), Returns()],
            ),
          ),
        ),
      ),
    );
  }
}
