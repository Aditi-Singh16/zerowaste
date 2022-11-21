import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  List<String> subtype;
  List<int> subtypeVal;
  CustomContainer({required this.subtype, required this.subtypeVal, Key? key})
      : super(key: key);

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.98,
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 113, 199, 116),
              Color.fromARGB(255, 86, 153, 207)
            ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Text(widget.subtype[i].toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
                Countup(
                  begin: 0,
                  end: widget.subtypeVal[i].toDouble(),
                  duration: const Duration(seconds: 3),
                  separator: ',',
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
              ]),
            );
          },
        ));
  }
}
