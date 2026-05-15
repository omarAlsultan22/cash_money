import 'base/app_exception.dart';


class SecurityAppException extends AppException {
  SecurityAppException({
    super.statusCode,
    super.message,
    super.error,
    super.code
  });
}