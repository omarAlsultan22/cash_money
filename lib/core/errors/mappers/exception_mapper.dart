import 'dart:io';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import '../exceptions/client_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/firebase_exception.dart';
import '../exceptions/base/app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/cache_exceptions/hive_exceptions.dart';
import '../exceptions/cache_exceptions/shared_prefs_exceptions.dart';
import 'package:cash_money/core/domain/services/connectivity_service/connectivity_service.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final connectivityService = ConnectivityService();
  static final Map<String, AppException> _stringPatterns = {
    '_casterror': SharedPrefsCastException(
      message: 'Error in stored data type',
    ),
    'null check operator': SharedPrefsCastException(
      message: 'Error in stored data type',
    ),
    'getinstance': SharedPrefsInitException(
      message: 'Local storage has not been initialized correctly',
    ),
    'not initialized': SharedPrefsInitException(
      message: 'Local storage has not been initialized correctly',
    ),
    'binding has not been initialized': SharedPrefsInitException(
      message: 'Local storage has not been initialized correctly',
    ),
    'read': SharedPrefsOperationException(
      message: 'Failed to read data from local storage',
      operation: 'read',
    ),
    'get': SharedPrefsOperationException(
      message: 'Failed to read data from local storage',
      operation: 'read',
    ),
    'write': SharedPrefsOperationException(
      message: 'Failed to save data to local storage',
      operation: 'write',
    ),
    'set': SharedPrefsOperationException(
      message: 'Failed to save data to local storage',
      operation: 'write',
    ),
    'save': SharedPrefsOperationException(
      message: 'Failed to save data to local storage',
      operation: 'write',
    ),
  };

  static final Map<Type, AppException Function(dynamic)> _typePatterns = {
    HiveError: (error) => HiveException(error: error.toString()),
    PlatformException: (error) =>
        SharedPrefsException(
          message: (error as PlatformException).code,
        ),
    MissingPluginException: (error) =>
        SharedPrefsException(
          message: (error as PlatformException).code,
        ),
    FirebaseException: (error) =>
        FirebaseAppException(
          error: (error as FirebaseException).message ?? 'Firebase error',
        ),
    SocketException: (error) =>
        NetworkException(
          error: 'No Internet Connection',
          connectivityService: connectivityService,
        ),
    TimeoutException: (error) =>
        NetworkException(
          error: 'Timeout expired, please try again later',
          connectivityService: connectivityService,
        ),
    FormatException: (error) =>
        ClientException(
          error: 'Invalid data format',
        ),
  };

  Iterable<String> get keys => _stringPatterns.keys;

  bool isKey(dynamic error) => _typePatterns.containsKey(error);

  bool isSharedPrefsError() {
    final errorStr = error.toString().toLowerCase();
    return error is PlatformException &&
        (errorStr.contains('shared_preferences') ||
            errorStr.contains('sharedpreferences')) ||
        error is MissingPluginException &&
            errorStr.contains('shared_preferences') ||
        errorStr.contains('sharedpreferences') ||
        errorStr.contains('preferences') && errorStr.contains('instance');
  }

  AppException? mapByType() {
    final exception = _stringPatterns[error];
    if (exception != null) {
      return exception;
    }
    return null;
  }

  AppException? mapByStringPattern() {
    final exception = _typePatterns[error]!(error);
    return exception;
  }
}