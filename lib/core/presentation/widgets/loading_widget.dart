import 'package:cash_money/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class LoadingWidget {
  static const sizedBox = SizedBox(
    height: 24,
    width: 24,
    child: CircularProgressIndicator(
      color: AppColors.black,
      strokeWidth: 3,
    ),
  );
}