import 'package:cash_money/core/constants/app_spaces.dart';
import 'package:flutter/material.dart';


class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final String? buttonText;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.buttonText = 'Retry',
  });

  static const _paddingHorizontal = 50.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _paddingHorizontal),
            child: Text('Error: $message'),
          ),
          AppSpaces.height_30,
          ElevatedButton(
            onPressed: onRetry,
            child: Text(buttonText!),
          ),
        ],
      ),
    );
  }
}