import '../base/app_exception.dart';
import 'base/cache_exceptions.dart';


class HiveException extends CacheException {
  HiveException({
    super.code,
    super.message,
    super.operation
  });

  static String? extractBoxName(String errorString) {
    // Create the Regex separately and safely
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static final Map<String,
      AppException Function(String errorMsg)> _errorFactories = {
    'box has already been closed': (msg) =>
        HiveBoxException(
          message: 'Attempting to access a closed database',
          code: 'HIVE_BOX_CLOSED',
        ),
    'box not found': (msg) =>
        HiveBoxException(
          message: 'Database does not exist',
          code: 'HIVE_BOX_NOT_FOUND',
        ),
    'box doesn\'t exist': (msg) =>
        HiveBoxException(
          message: 'Database does not exist',
          code: 'HIVE_BOX_NOT_FOUND',
        ),
    'null': (msg) =>
        HiveBoxException(
          message: 'Database has not been initialized correctly',
          code: 'HIVE_BOX_NULL',
        ),
    'box': (msg) =>
        HiveBoxException(
          message: 'Database has not been initialized correctly',
          code: 'HIVE_BOX_NULL',
        ),
    'openbox': (msg) =>
        HiveOpenBoxException(
          boxName: extractBoxName(msg) ?? 'unknown',
          message: 'Failed to open database: $msg',
        ),
    'failed to open': (msg) =>
        HiveOpenBoxException(
          boxName: extractBoxName(msg) ?? 'unknown',
          message: 'Failed to open database: $msg',
        ),
    'filesystemexception': (msg) =>
        HiveOperationException(
          message: 'An error occurred in the database file',
          operation: 'file_system',
        ),
    'file closed': (msg) =>
        HiveOperationException(
          message: 'An error occurred in the database file',
          operation: 'file_system',
        ),
    'compaction': (msg) =>
        HiveOperationException(
          message: 'An error occurred while compacting the database',
          operation: 'compaction',
        ),
    'encryption': (msg) =>
        HiveOperationException(
          message: 'Error in database encryption/decryption',
          operation: 'encryption',
        ),
    'decryption': (msg) =>
        HiveOperationException(
          message: 'Error in database encryption/decryption',
          operation: 'encryption',
        ),
    'put': (msg) =>
        HiveOperationException(
          message: 'Failed to save data to database',
          operation: 'put',
        ),
    'get': (msg) =>
        HiveOperationException(
          message: 'Failed to read data from database',
          operation: 'get',
        ),
    'delete': (msg) =>
        HiveOperationException(
          message: 'Failed to delete data from database',
          operation: 'delete',
        ),
  };

  @override
  AppException getException(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    final isKeyFound = _errorFactories.containsKey(error);
    if (isKeyFound) {
      return _errorFactories[errorStr]!(errorStr);
    }
    return HiveOperationException(
      message: error.error ?? 'Local storage error: ${error.toString()}',
    );
  }
}


class HiveCacheException extends HiveException {
  HiveCacheException({
    required super.message,
    super.code = 'HIVE_ERROR',
    super.operation,
  });
}

/// خطأ في Box (مغلق، غير موجود، null)
class HiveBoxException extends HiveException {
  final String? boxName;

  HiveBoxException({
    required super.message,
    this.boxName,
    super.code = 'HIVE_BOX_ERROR',
  });
}

/// خطأ في فتح Hive Box
class HiveOpenBoxException extends HiveException {
  final String boxName;
  final String? path;

  HiveOpenBoxException({
    required this.boxName,
    required super.message,
    this.path,
    super.code = 'HIVE_OPEN_BOX_ERROR',
  });
}

/// خطأ في إغلاق Hive Box
class HiveCloseBoxException extends HiveException {
  HiveCloseBoxException({
    super.message,
    super.code = 'HIVE_CLOSE_BOX_ERROR',
  });
}

/// خطأ في عمليات CRUD على Hive
class HiveOperationException extends HiveException {
  final String? boxName;
  final dynamic key;

  HiveOperationException({
    required super.message,
    this.boxName,
    this.key,
    super.operation,
    super.code = 'HIVE_OPERATION_ERROR',
  });
}

/// خطأ في حفظ البيانات إلى Hive
class HiveSaveException extends HiveException {
  HiveSaveException({
    required super.message,
    super.operation = 'save',
    super.code = 'HIVE_SAVE_ERROR',
  });
}

/// خطأ في قراءة البيانات من Hive
class HiveReadException extends HiveException {
  HiveReadException({
    required super.message,
    super.operation = 'read',
    super.code = 'HIVE_READ_ERROR',
  });
}

/// خطأ في حذف البيانات من Hive
class HiveDeleteException extends HiveException {
  HiveDeleteException({
    required super.message,
    super.operation = 'delete',
    super.code = 'HIVE_DELETE_ERROR',
  });
}

/// خطأ في مسح كامل Box
class HiveClearException extends HiveException {
  HiveClearException({
    required super.message,
    super.operation = 'clear',
    super.code = 'HIVE_CLEAR_ERROR',
  });
}