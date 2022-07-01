import 'package:flutter/material.dart';

abstract class AppColor {
  static const LinearGradient gradient = LinearGradient(
    colors: [
      Colors.white,
      Color.fromARGB(255, 0, 128, 128),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color primary = Color.fromARGB(255, 0, 128, 128);
  static const Color secondary = Color.fromARGB(255, 0, 20, 39);
  static const Color text = Color(0xFF32303d);
  static const Color accent = Color(0xFFFFFFFF);
  static const Color accent_1 = Color(0xFFefeff6);
  static const Color accent_2 = Color(0xFFeef6ff);
  static const Color accent_3 = Color(0xFFfff7f4);
  static const Color accent_4 = Color(0xFFffe4ea);
}
