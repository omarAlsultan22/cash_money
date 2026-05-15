import 'base/app_exception.dart';
import 'package:flutter/cupertino.dart';
import '../../presentation/widgets/internet_unavailability.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class AppNetworkException extends AppException {
  final ConnectivityService? connectivityService;

  AppNetworkException({
    super.error,
    super.message,
    this.connectivityService
  });

  @override
  AppException getException() {
    return AppNetworkException(
        message: error.toString()
    );
  }

  @override
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return InternetUnavailability(
      message: message,
      onRetry: onRetry,
      connectivityService: connectivityService,
    );
  }
}