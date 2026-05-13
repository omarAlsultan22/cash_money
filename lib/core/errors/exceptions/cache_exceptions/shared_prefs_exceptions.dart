import '../base/app_exception.dart';
import 'base/cache_exceptions.dart';


class SharedPrefsException extends CacheException {
  SharedPrefsException({
    super.code,
    super.operation,
    super.statusCode, Object? message,
  });

  static final Map<String, AppException> _exactMatches = {
    'streamcorrupted': SharedPrefsInitException(
      message: 'Local storage file is corrupted, it will be reinitialized',
      platformCode: 'STREAM_CORRUPTED',
    ),
    'invalid stream header': SharedPrefsInitException(
      message: 'Local storage file is corrupted, it will be reinitialized',
      platformCode: 'INVALID_STREAM_HEADER',
    ),
    'channel-error': SharedPrefsPlatformException(
      message: 'Connection issue with storage system',
      platformCode: 'CHANNEL_ERROR',
    ),
    'unable to establish connection': SharedPrefsPlatformException(
      message: 'Connection issue with storage system',
      platformCode: 'CONNECTION_FAILED',
    ),
  };

  @override
  AppException getException(dynamic error) {
    final isKeyFound = _exactMatches.containsKey(error);
    if (isKeyFound) {
      final value = _exactMatches[error];
      if (value != null) {
        return value;
      }
    }
    return SharedPrefsPlatformException(
      message: error.error ?? 'Local storage platform error',
      platformCode: error.code,
    );
  }
}


class SharedPrefsInitException extends SharedPrefsException {
  final String? platformCode;

  SharedPrefsInitException({
    super.message,
    this.platformCode,
    super.code = 'SHARED_PREFS_INIT_ERROR',
  });
}


class SharedPrefsPlatformException extends SharedPrefsException {
  final String? platformCode;

  SharedPrefsPlatformException({
    super.message,
    this.platformCode,
    super.code = 'SHARED_PREFS_PLATFORM_ERROR',
  });
}


class SharedPrefsOperationException extends SharedPrefsException {
  final String? key;

  SharedPrefsOperationException({
    required super.message,
    this.key,
    super.operation,
    super.code = 'SHARED_PREFS_OPERATION_ERROR',
  });
}


class SharedPrefsCastException extends SharedPrefsException {
  final String? key;
  final String? expectedType;

  SharedPrefsCastException({
    super.message,
    this.key,
    this.expectedType,
    super.code = 'SHARED_PREFS_CAST_ERROR',
  });
}