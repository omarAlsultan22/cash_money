import 'base/app_exception.dart';


class ClientException extends AppException {
  ClientException({
    required super.error,
    super.statusCode,
    super.code
  });

  @override
  AppException getException() {
    return ClientException(
        error: error.toString(),
        statusCode: statusCode);
  }
}