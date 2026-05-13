import 'base/app_exception.dart';


class ServerException extends AppException {
  ServerException({
    super.code,
    required super.message,
    required super.statusCode
  });

  @override
  AppException getException(dynamic error) {
    return ServerException(
        message: error.toString(),
        statusCode: statusCode);
  }
}