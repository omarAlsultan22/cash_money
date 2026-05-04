import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';


class InitialStateWidget extends StatelessWidget {
  const InitialStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Color(0xFFE0E0E0),
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: AppSizes.fontSize_16,
              fontWeight: FontWeight.bold,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}