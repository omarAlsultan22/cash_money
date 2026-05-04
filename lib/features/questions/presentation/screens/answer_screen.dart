import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import '../../../../core/presentation/widgets/icon_button_widget.dart';


class AnswerScreen extends StatelessWidget {
  final String answer;
  final bool isCorrect;

  const AnswerScreen({
    Key? key,
    required this.answer,
    required this.isCorrect,
  }) : super(key: key);

  static const _borderRadius = 15.0;
  static const _paddingValue = 12.0;
  static const _paddingForAll = EdgeInsets.all(_paddingValue);

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown_900,
      appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: AppSizes.none,
          leading: const IconButtonWidget()
      ),
      body: Center(
        child: Padding(
          padding: _paddingForAll,
          child: Card(
            elevation: 8,
            color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: Padding(
              padding: _paddingForAll,
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: AppSizes.fontSize_24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }
}