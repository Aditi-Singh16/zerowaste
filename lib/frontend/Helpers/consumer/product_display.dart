import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/style.dart';

class ProductNameAndPrice extends StatelessWidget {
  String name;
  double amount;
  String category;
  ProductNameAndPrice(
      {required this.amount, required this.name, required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: AppStyle.h1Light.copyWith(fontSize: 18),
        ),
        Text(
          '\u20B9 $amount',
          style: AppStyle.h1Light
              .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
