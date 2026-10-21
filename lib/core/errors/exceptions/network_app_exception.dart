import 'base/app_exception.dart';
import 'package:flutter/cupertino.dart';
import '../../network/domain/i_connectivity_service.dart';
import '../../presentation/widgets/internet_unavailability.dart';


class NetworkAppException extends AppException {
  final IConnectivityService? connectivityService;

  NetworkAppException({
    super.error,
    super.message,
    this.connectivityService
  });

  @override
  Widget buildErrorWidget(
      {PreferredSizeWidget? appBar, VoidCallback? onRetry}) {
    return InternetUnavailability(
      appBar: appBar,
      message: message,
      onRetry: onRetry,
      connectivityProvider: connectivityService,
    );
  }
}