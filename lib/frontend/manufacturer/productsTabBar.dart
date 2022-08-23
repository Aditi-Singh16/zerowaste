import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/manufacturer/addProduct.dart';
import 'package:zerowaste/frontend/requirements_sell/view_requirements.dart';

class ProductsTabBar extends StatelessWidget {
  const ProductsTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xff001427),
            title: Text(
              'Products',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Add Products",
                ),
                Tab(text: "View Requirements"),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [AddProduct(), ViewRequirements()],
            ),
          ),
        ),
      ),
    );
  }
}
