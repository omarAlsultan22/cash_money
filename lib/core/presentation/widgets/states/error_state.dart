import 'package:cash_money/core/constants/app_spaces.dart';
import '../../../constants/app_colors.dart';
import 'package:flutter/material.dart';


class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final String buttonText;
  final VoidCallback? onRetry;
  final PreferredSizeWidget? appBar;

  const ErrorStateWidget({
    super.key,
    required this.appBar,
    required this.message,
    required this.onRetry,
    this.buttonText = 'Retry',
  });

  static const _paddingHorizontal = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown_900,
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: _paddingHorizontal),
              child: Text('Error: $message'),
            ),
            AppSpaces.vertical_30,
            ElevatedButton(
              onPressed: onRetry,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}