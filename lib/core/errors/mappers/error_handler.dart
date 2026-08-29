import 'package:cash_money/core/errors/mappers/exception_mapper.dart';
import '../exceptions/shared_prefs_app_exceptions.dart';
import '../exceptions/unknown_app_exception.dart';
import '../exceptions/components_exception.dart';
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
        _componentsException() ??
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

  AppException? _componentsException() {
    return error is ComponentsException ? error : null;
  }

  AppException? _sharedPrefsException() {
    return error is SharedPrefsAppException ? error : null;
  }

  AppException? _validationException() {
    return error is ValidationException ? error : null;
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
