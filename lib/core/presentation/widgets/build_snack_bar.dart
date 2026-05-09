import 'package:flutter/material.dart';


class BuildSnackBar {
  static const _durationSeconds = 3;

  static SnackBar build(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      duration: const Duration(seconds: _durationSeconds),
    );
  }
}