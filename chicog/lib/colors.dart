import 'package:flutter/material.dart';

class Pallete {
  static const MaterialColor myColor =
      MaterialColor(_myColorPrimaryValue, <int, Color>{
    50: Color(0xFF9D2235),
    100: Color(0xFFE2BDC2),
    200: Color(0xFFCE919A),
    300: Color(0xFFBA6472),
    400: Color(0xFFAC4353),
    500: Color(_myColorPrimaryValue),
    600: Color(0xFF951E30),
    700: Color(0xFF8B1928),
    800: Color(0xFF811422),
    900: Color(0xFF6F0C16),
  });
  static const MaterialColor myColorAccent =
    MaterialColor(_myColorAccentValue, <int, Color>{
  100: Color(0xFFFFA1A9),
  200: Color(_myColorAccentValue),
  400: Color(0xFFFF3B4A),
  700: Color(0xFFFF2233),
});
}
const int _myColorPrimaryValue = 0xFF9D2235;
const int _myColorAccentValue = 0xFFFF6E79;
