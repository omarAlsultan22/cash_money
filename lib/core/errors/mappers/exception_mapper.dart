import 'dart:io';
import 'dart:async';
import '../exceptions/base/app_exception.dart';
import '../exceptions/client_app_exception.dart';
import '../../services/connectivity_service.dart';
import '../exceptions/network_app_exception.dart';
import '../exceptions/firebase_app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static final _connectivityService = ConnectivityService();

  static final Map<Object, AppException? Function(dynamic)> _typePatterns = {
    FirebaseException: (error) {
      final firebaseException = FirebaseAppException(
        message: (error as FirebaseException).message ?? 'خطأ في Firebase',
        error: error,
      );
      return firebaseException.handle();
    },
    SocketException: (error) =>
        NetworkAppException(
          message: 'No Internet Connection',
          connectivityService: _connectivityService,
        ),
    TimeoutException: (error) =>
        NetworkAppException(
          message: 'Timeout expired, please try again later',
          connectivityService: _connectivityService,
        ),
    FormatException: (error) =>
        ClientAppException(
          message: error.message ?? 'Invalid data format',
        ),
  };

  bool get isKey => _typePatterns.containsKey(error);

  AppException? mapByTypePattern() {
    return _typePatterns[error]!(error);
  }
}