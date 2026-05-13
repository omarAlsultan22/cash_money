import '../../base/app_exception.dart';


abstract class CacheException extends AppException {
  final String? operation;

  const CacheException({
    super.code,
    super.message,
    this.operation,
    super.statusCode,
  });
}
