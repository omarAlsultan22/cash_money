import 'package:cash_money/core/presentation/widgets/app_spacing.dart';
import 'package:flutter/material.dart';


class ConnectionErrorStateWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ConnectionErrorStateWidget({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.wifi_off, size: 50.0),
          const SizedBox(width: 10.0),
          const Text('No Internet Connection',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              )
          ),
          AppSpacing.height_30,
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
