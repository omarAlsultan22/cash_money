import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:cash_money/core/constants/app_spaces.dart';
import 'package:flutter/material.dart';


class InternetUnavailability extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final ConnectivityService? connectivityService;

  const InternetUnavailability({
    super.key,
    this.onRetry,
    this.message,
    this.connectivityService
  });

  static const _spacing = 20.0;
  static const _fontSize = 24.0;

  @override
  Widget build(BuildContext context) {
    Future<void> isInternetAvailable() async {
      final isConnected = await connectivityService!.checkInternetConnection();
      if (isConnected) {
        onRetry?.call();
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 80.0,
            color: Color(0xFF757575),
          ),
          const SizedBox(height: _spacing),
          Text(message!,
              style: const TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242)
              )
          ),
          AppSpaces.height_30,
          ElevatedButton(
            onPressed: isInternetAvailable,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
