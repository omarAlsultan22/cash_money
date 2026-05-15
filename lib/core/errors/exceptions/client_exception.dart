import 'base/app_exception.dart';


class AppClientException extends AppException {
  AppClientException({
    required super.error,
    super.statusCode,
    super.code
  });

  @override
  AppException getException() {
    return AppClientException(
        error: error.toString(),
        statusCode: statusCode);
  }
}