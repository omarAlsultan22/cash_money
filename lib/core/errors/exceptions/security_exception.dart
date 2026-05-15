import 'base/app_exception.dart';


class SecurityException extends AppException {
  SecurityException({
    super.statusCode,
    super.message,
    super.error,
    super.code
  });

  @override
  AppException getException() {
    return SecurityException(
        message: error.toString(),
        statusCode: statusCode
    );
  }
}