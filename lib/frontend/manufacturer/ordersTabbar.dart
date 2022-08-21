import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/manufacturer/Orders.dart';
import 'package:zerowaste/frontend/manufacturer/addProduct.dart';
import 'package:zerowaste/frontend/manufacturer/returns.dart';
import 'package:zerowaste/frontend/requirements_sell/view_requirements.dart';

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
            backgroundColor: Color(0xff001427),
            title: Text(
              'Orders and returns',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            bottom: TabBar(
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
