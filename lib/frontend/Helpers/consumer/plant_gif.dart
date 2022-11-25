// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';

class PlantGIF extends StatelessWidget {
  const PlantGIF({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!!!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/images/plantatree.gif"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.appcolor1),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
