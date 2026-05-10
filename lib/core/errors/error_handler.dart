import 'dart:io';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'exceptions/client_exception.dart';
import 'exceptions/cache_exceptions.dart';
import 'exceptions/unknown_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/base/app_exception.dart';
import 'exceptions/firebase_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/services/connectivity_service/connectivity_service.dart';


class ErrorHandler {

  // ==================== Main Function ====================

  static AppException handleException(dynamic error, {StackTrace? stackTrace}) {
    // Log the error (for analytics)
    _logError(error, stackTrace);
    final connectivityService = ConnectivityService();
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
        case 'network-error':
        case 'network-request-failed':
          return NetworkException(
              message: 'No Internet Connection',
              connectivityService: connectivityService);
        case 'permission-denied':
          return FirebaseAppException(
              message: 'You do not have permission to access');
        case 'not-found':
          return FirebaseAppException(message: 'Data not found');
        case 'already-exists':
          return FirebaseAppException(message: 'Data already exists');
        case 'user-not-found':
          return FirebaseAppException(
              message: 'No user registered with this email');
        case 'invalid-email':
          return FirebaseAppException(message: 'Invalid email address');
        default:
          return FirebaseAppException(message: 'Firebase error');
      }
    }

    if (_isSharedPrefsError(error)) {
      return _handleSharedPrefsError(error, stackTrace);
    }

    if (error is HiveError) {
      return _handleHiveError(error, stackTrace);
    }

    if (error is SocketException) {
      return NetworkException(
          message: 'No Internet Connection',
          connectivityService: connectivityService
      );
    }

    if (error is TimeoutException) {
      return NetworkException(
          message: 'Timeout expired, please try again later',
          connectivityService: connectivityService
      );
    }

    if (error is FormatException) {
      return ClientException(message: 'Invalid data format');
    }

    // 7. Any other error
    return UnknownException(message: error.toString());
  }

  // ==================== Helper Function for Checking ====================

  static bool _isSharedPrefsError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return error is PlatformException &&
        (errorStr.contains('shared_preferences') ||
            errorStr.contains('sharedpreferences')) ||
        error is MissingPluginException &&
            errorStr.contains('shared_preferences') ||
        errorStr.contains('sharedpreferences') ||
        errorStr.contains('preferences') && errorStr.contains('instance');
  }

  // ==================== SharedPreferences Error Handler ====================

  static AppException _handleSharedPrefsError(dynamic error,
      StackTrace? stackTrace) {
    final errorStr = error.toString().toLowerCase();

    // PlatformException (most common)
    if (error is PlatformException) {
      final message = error.message?.toLowerCase() ?? '';

      if (message.contains('streamcorrupted') ||
          message.contains('invalid stream header')) {
        return SharedPrefsInitException(
          message: 'Local storage file is corrupted, it will be reinitialized',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      if (message.contains('channel-error') ||
          message.contains('unable to establish connection')) {
        return SharedPrefsPlatformException(
          message: 'Connection issue with storage system',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      return SharedPrefsPlatformException(
        message: error.message ?? 'Local storage platform error',
        platformCode: error.code,
        stackTrace: stackTrace,
      );
    }

    // MissingPluginException
    if (error is MissingPluginException) {
      return SharedPrefsPluginException(
        message: 'Local storage initialization issue, please restart the application',
        stackTrace: stackTrace,
      );
    }

    // _CastError (type conversion error)
    if (errorStr.contains('_casterror') ||
        errorStr.contains('null check operator')) {
      return SharedPrefsCastException(
        message: 'Error in stored data type',
        stackTrace: stackTrace,
      );
    }

    // General initialization errors
    if (errorStr.contains('getinstance') ||
        errorStr.contains('not initialized') ||
        errorStr.contains('binding has not been initialized')) {
      return SharedPrefsInitException(
        message: 'Local storage has not been initialized correctly',
        stackTrace: stackTrace,
      );
    }

    // Read/write errors
    if (errorStr.contains('read') || errorStr.contains('get')) {
      return SharedPrefsOperationException(
        message: 'Failed to read data from local storage',
        operation: 'read',
        stackTrace: stackTrace,
      );
    }

    if (errorStr.contains('write') || errorStr.contains('set') ||
        errorStr.contains('save')) {
      return SharedPrefsOperationException(
        message: 'Failed to save data to local storage',
        operation: 'write',
        stackTrace: stackTrace,
      );
    }

    // Any other error
    return SharedPrefsOperationException(
      message: 'Local storage error: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== Hive Error Handler ====================

  static AppException _handleHiveError(dynamic error, StackTrace? stackTrace) {
    final errorString = error.toString().toLowerCase();

    // Box errors
    if (errorString.contains('box has already been closed')) {
      return HiveBoxException(
        message: 'Attempting to access a closed database',
        code: 'HIVE_BOX_CLOSED',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('box not found') ||
        errorString.contains('box doesn\'t exist')) {
      return HiveBoxException(
        message: 'Database does not exist',
        code: 'HIVE_BOX_NOT_FOUND',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('null') && errorString.contains('box')) {
      return HiveBoxException(
        message: 'Database has not been initialized correctly',
        code: 'HIVE_BOX_NULL',
        stackTrace: stackTrace,
      );
    }

    // Box opening errors
    if (errorString.contains('openbox') ||
        errorString.contains('failed to open')) {
      final boxName = _extractBoxName(errorString);
      return HiveOpenBoxException(
        boxName: boxName ?? 'unknown',
        message: 'Failed to open database: ${error.toString()}',
        stackTrace: stackTrace,
      );
    }

    // Hive file errors
    if (errorString.contains('filesystemexception') ||
        errorString.contains('file closed')) {
      return HiveOperationException(
        message: 'An error occurred in the database file',
        operation: 'file_system',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('compaction')) {
      return HiveOperationException(
        message: 'An error occurred while compacting the database',
        operation: 'compaction',
        stackTrace: stackTrace,
      );
    }

    // Encryption errors
    if (errorString.contains('encryption') ||
        errorString.contains('decryption')) {
      return HiveOperationException(
        message: 'Error in database encryption/decryption',
        operation: 'encryption',
        stackTrace: stackTrace,
      );
    }

    // CRUD operation errors
    if (errorString.contains('put')) {
      return HiveOperationException(
        message: 'Failed to save data to database',
        operation: 'put',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('get')) {
      return HiveOperationException(
        message: 'Failed to read data from database',
        operation: 'get',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('delete')) {
      return HiveOperationException(
        message: 'Failed to delete data from database',
        operation: 'delete',
        stackTrace: stackTrace,
      );
    }

    // Any other Hive error
    if (error is HiveError) {
      return HiveOperationException(
        message: error.message,
        stackTrace: stackTrace,
      );
    }

    return HiveCacheException(
      message: 'Local storage error: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== Helper Functions ====================

  static String? _extractBoxName(String errorString) {
    // Create the Regex separately and safely
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static void _logError(dynamic error, StackTrace? stackTrace) {
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