import 'package:cash_money/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class InitialStateWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const InitialStateWidget({required this.text, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.brown_900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 100.0,
                color: const Color(0xFFE0E0E0),
              ),
              Text(
                'No $text Found',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        )
    );
  }
}