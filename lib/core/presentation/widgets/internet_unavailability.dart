import 'icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:cash_money/core/constants/app_spaces.dart';
import 'package:cash_money/core/services/connectivity_service.dart';


class InternetUnavailability extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final PreferredSizeWidget? appBar;
  final ConnectivityService? connectivityProvider;

  const InternetUnavailability({
    super.key,
    this.appBar,
    this.onRetry,
    this.message,
    this.connectivityProvider
  });

  @override
  Widget build(BuildContext context) {
    Future<void> isInternetAvailable() async {
      final isConnected = await connectivityProvider!.checkInternetConnection();
      if (isConnected) {
        onRetry?.call();
      }
    }

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 80.0,
              color: Color(0xFF757575),
            ),
            const SizedBox(height: 20.0),
            Text(message!,
                style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242)
                )
            ),
            AppSpaces.vertical_30,
            ElevatedButton(
              onPressed: isInternetAvailable,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
