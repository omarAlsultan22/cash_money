import 'package:cash_money/core/errors/mappers/exception_mapper.dart';
import '../exceptions/shared_prefs_app_exceptions.dart';
import '../exceptions/unknown_app_exception.dart';
import '../exceptions/validation_exception.dart';
import '../exceptions/base/app_exception.dart';


class ErrorHandler {
  final dynamic error;
  final StackTrace stackTrace;
  late final ExceptionMapper _exceptionMapper;

  ErrorHandler({
    required this.error,
    required this.stackTrace
  }) {
    _exceptionMapper = ExceptionMapper(error: error);
  }

  // ==================== Main Function ====================

  AppException handleException() {
    // Log the error (for analytics)
    _logError(error, stackTrace);

    return _mapByTypePattern() ??
        _sharedPrefsException() ??
        _validationException() ??
        UnknownAppException(message: error.toString());
  }

  // ==================== Helper Functions for Checking ====================

  AppException? _mapByTypePattern() {
    if (_exceptionMapper.isKey) {
      return _exceptionMapper.mapByTypePattern();
    }
    return null;
  }

  AppException? _sharedPrefsException() {
    if (error is SharedPrefsAppException) {
      return error;
    }
    return null;
  }

  AppException? _validationException() {
    if (error is ValidationException) {
      return error;
    }
    return null;
  }

  void _logError(dynamic error, StackTrace? stackTrace) {
    // For tracking and analytics
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}
