import 'package:flutter/material.dart';

class DetailsFieldTab extends StatefulWidget {
  String field;
  String name;
  DetailsFieldTab({required this.field, required this.name, Key? key})
      : super(key: key);

  @override
  State<DetailsFieldTab> createState() => _DetailsFieldTabState();
}

class _DetailsFieldTabState extends State<DetailsFieldTab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.field,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          widget.name,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
