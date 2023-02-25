import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';
import 'package:zerowaste/frontend/constants.dart';

class ScratchCard extends StatefulWidget {
  String coupon;
  ScratchCard({required this.coupon, Key? key}) : super(key: key);

  @override
  State<ScratchCard> createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Scratcher(
        brushSize: 100,
        threshold: 50,
        color: Colors.blue,
        onChange: (value) => print("Scratch progress: $value%"),
        onThreshold: () => print("Threshold reached"),
        onScratchEnd: () {},
        child: Container(
          height: MediaQuery.of(context).size.height * 0.42,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(
                  "assets/images/cele.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "You\'ve won",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      letterSpacing: 1,
                      color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                widget.coupon,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.blue),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                AppConstants.couponDescription[widget.coupon]!,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
