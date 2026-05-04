import 'package:flutter/cupertino.dart';


mixin AppPaddings {
  static const _small = 16.0;
  static const _medium = 20.0;
  static const _large = 24.0;

  static const vertical = _small;
  static const medium = EdgeInsets.all(_medium);
  static const large = EdgeInsets.all(_large);
  static const symmetricVertical = EdgeInsets.symmetric(vertical: vertical);
}