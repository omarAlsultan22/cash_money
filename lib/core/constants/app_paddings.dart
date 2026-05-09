import 'package:flutter/cupertino.dart';


abstract class AppPaddings {
  static const double _small = 16.0;
  static const double _medium = 20.0;
  static const double _large = 24.0;

  static const EdgeInsets medium = EdgeInsets.all(_medium);
  static const EdgeInsets large = EdgeInsets.all(_large);
  static const EdgeInsets symmetricVertical = EdgeInsets.symmetric(
      vertical: _small);
}