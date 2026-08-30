import 'dart:io';
import 'dart:async';
import '../exceptions/base/app_exception.dart';
import '../exceptions/client_app_exception.dart';
import '../exceptions/components_exception.dart';
import '../exceptions/validation_exception.dart';
import '../../services/connectivity_service.dart';
import '../exceptions/network_app_exception.dart';
import '../exceptions/firebase_app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/shared_prefs_app_exceptions.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final _connectivityService = ConnectivityService();

  static final Map<Object, AppException? Function(dynamic)> _typePatterns = {
    ValidationException: (error) => error,

    ComponentsException: (error) => error,

    SharedPrefsAppException: (error) => error,

    NetworkAppException: (error) => error,

    FirebaseException: (error) {
      final firebaseException = FirebaseAppException(
        message: (error as FirebaseException).message ?? 'خطأ في Firebase',
        error: error,
      );
      return firebaseException.handle();
    },
    SocketException: (_) =>
        NetworkAppException(
          message: 'No Internet Connection',
          connectivityService: _connectivityService,
        ),
    TimeoutException: (_) =>
        NetworkAppException(
          message: 'Timeout expired, please try again later',
          connectivityService: _connectivityService,
        ),
    FormatException: (_) =>
        ClientAppException(
          message: 'Invalid data format',
        ),
  };

  bool get isKey => _typePatterns.containsKey(error);

  AppException? mapByTypePattern() {
    return _typePatterns[error]!(error);
  }
}