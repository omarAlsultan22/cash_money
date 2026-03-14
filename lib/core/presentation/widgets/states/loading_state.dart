import 'package:cash_money/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.brown_900,
      body: Center(child: CircularProgressIndicator(color: AppColors.white)),
    );
  }
}
