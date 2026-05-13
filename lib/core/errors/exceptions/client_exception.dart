import 'base/app_exception.dart';


class ClientException extends AppException {
  ClientException({
    required super.message,
    super.statusCode,
    super.code
  });

  @override
  AppException getException(dynamic error) {
    return ClientException(
        message: error.toString(),
        statusCode: statusCode);
  }
}