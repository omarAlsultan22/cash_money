import 'base/app_exception.dart';
import 'package:flutter/cupertino.dart';
import '../../presentation/widgets/states/error_state.dart';


class UnknownException extends AppException{
  UnknownException({
    required super.message
  });

  @override
  AppException getException() {
    return UnknownException(message: message);
  }

  @override
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return ErrorStateWidget(message: message, onRetry: onRetry);
  }
}