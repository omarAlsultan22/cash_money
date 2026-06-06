import 'package:cash_money/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class InitialStateWidget extends StatelessWidget {
  const InitialStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('No data found',
            style: TextStyle(color: AppColors.white
            )
        )
    );
  }
}