import 'base/app_exception.dart';
import 'package:flutter/cupertino.dart';
import '../../presentation/widgets/internet_unavailability.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class NetworkException extends AppException {
  final ConnectivityService? connectivityService;

  NetworkException({
    super.message,
    this.connectivityService
  });

  @override
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return InternetUnavailability(
      message: message,
      onRetry: onRetry,
      connectivityService: connectivityService,
    );
  }
}