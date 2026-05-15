import 'base/app_exception.dart';


class ClientAppException extends AppException {
  ClientAppException({
    required super.error,
    super.statusCode,
    super.code
  });
}