import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: const Center(
            child: SpinKitChasingDots(
          color: Colors.blue,
          size: 50.0,
        )));
  }
}
