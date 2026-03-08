import 'package:cash_money/core/presentation/widgets/app_spacing.dart';
import 'package:flutter/material.dart';


class ConnectionErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ConnectionErrorStateWidget(
      {required this.error, required this.onRetry, super.key});

  Widget retryButton() {
    return Column(
      children: [
        AppSpacing.height_30,
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off),
            const SizedBox(width: 10.0),
            Text(error)
          ],
        ),
        retryButton()
      ],
    );
  }
}
