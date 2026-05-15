import 'base/app_exception.dart';


class AppSecurityException extends AppException {
  AppSecurityException({
    super.statusCode,
    super.message,
    super.error,
    super.code
  });

  @override
  AppException getException() {
    return AppSecurityException(
        message: error.toString(),
        statusCode: statusCode
    );
  }
}