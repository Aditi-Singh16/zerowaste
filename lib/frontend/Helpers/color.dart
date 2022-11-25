import 'package:flutter/material.dart';

abstract class AppColor {
  static const LinearGradient gradient = LinearGradient(
    colors: [
      Colors.white,
      Color(0xff80cc28),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static List<List<Color>> popupGridColor = [
    [Colors.blue[100]!, Colors.blue],
    [Colors.red[100]!, Colors.red],
  ];
  static const Color primary = Color.fromARGB(255, 0, 128, 128);
  static const Color secondary = Color.fromARGB(255, 0, 20, 39);
  static const Color text = Color(0xff022078);
  static const Color dropdown = Color(0xff3b74c4);
  static const Color appcolor1 = Color(0xff6fd1eb);
  static const Color appcolor2 = Color(0xff80cc28);
  static const Color appcolor3 = Color(0xff40b83d);
  static const Color accent = Color(0xFFFFFFFF);
  static const Color accent_1 = Color(0xFFefeff6);
  static const Color accent_2 = Color(0xFFeef6ff);
  static const Color accent_3 = Color(0xFFfff7f4);
  static const Color accent_4 = Color(0xFFffe4ea);
}
