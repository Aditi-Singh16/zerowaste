import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/manufacturer/addProduct.dart';
import 'package:zerowaste/frontend/manufacturer/view_requirements.dart';

class ProductsTabBar extends StatelessWidget {
  const ProductsTabBar({Key? key}) : super(key: key);

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
            leading: Image.asset(
              'assets/images/logo1.png',
              fit: BoxFit.contain,
            ),
            title: Text("Products"),
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
