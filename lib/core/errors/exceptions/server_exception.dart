import 'base/app_exception.dart';


class ServerException extends AppException {
  ServerException({
    super.code,
    super.error,
    super.message,
    required super.statusCode
  });

  @override
  AppException getException() {
    return ServerException(
        message: error.toString(),
        statusCode: statusCode
    );
  }
}