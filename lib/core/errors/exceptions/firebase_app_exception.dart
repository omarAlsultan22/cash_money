import 'base/app_exception.dart';
import 'network_app_exception.dart';
import 'base/exception_handler.dart';
import '../../services/connectivity_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseAppException extends AppException implements ExceptionHandler {
  FirebaseAppException({
    super.code,
    super.error,
    super.message
  });

  static final _connectivityService = ConnectivityService();
  static const String _msgNoInternet = 'No Internet Connection';

  static final Map<String, AppException> _errorFactories = {
    // Network
    'unavailable': NetworkAppException(
        message: _msgNoInternet, connectivityService: _connectivityService),
    'network-error': NetworkAppException(
        message: _msgNoInternet, connectivityService: _connectivityService),
    'network-request-failed': NetworkAppException(
        message: _msgNoInternet, connectivityService: _connectivityService),

    // Firestore
    'permission-denied': FirestoreAppException(code: 'permission-denied',
        message: 'You do not have permission to access'),
    'not-found': FirestoreAppException(
        code: 'not-found', message: 'Data not found'),
    'already-exists': FirestoreAppException(
        code: 'already-exists', message: 'Data already exists'),
    'unauthenticated': FirestoreAppException(
        code: 'unauthenticated', message: 'User is not authenticated'),
    'failed-precondition': FirestoreAppException(
        code: 'failed-precondition', message: 'Failed precondition'),
    'deadline-exceeded': FirestoreAppException(
        code: 'deadline-exceeded',
        message: 'Request timed out, please try again'),
    'resource-exhausted': FirestoreAppException(
        code: 'resource-exhausted',
        message: 'Server limit reached, try again later'),
    'cancelled': FirestoreAppException(
        code: 'cancelled',
        message: 'Operation cancelled'),
    'aborted': FirestoreAppException(
        code: 'aborted',
        message: 'Transaction failed, please retry'),
    'fetch-failed': FirestoreAppException(
        code: 'fetch-failed',
        message: 'Failed to load data, please check your connection'),
    'data-corrupted': FirestoreAppException(
        code: 'data-corrupted',
        message: 'Invalid data format'),

    // Auth
    'user-not-found': AuthAppException(
        code: 'user-not-found', message: 'No user registered with this email'),
    'invalid-email': AuthAppException(
        code: 'invalid-email', message: 'Invalid email address'),
    'wrong-password': AuthAppException(
        code: 'wrong-password', message: 'Wrong password'),
    'email-already-in-use': AuthAppException(
        code: 'email-already-in-use', message: 'Email already in use'),
    'weak-password': AuthAppException(
        code: 'weak-password', message: 'Weak password'),
    'user-disabled': AuthAppException(
        code: 'user-disabled', message: 'User account is disabled'),
    'too-many-requests': AuthAppException(code: 'too-many-requests',
        message: 'Too many requests, try again later'),
    'invalid-credential': AuthAppException(
        code: 'invalid-credential', message: 'Invalid login credentials'),
    'requires-recent-login': AuthAppException(
        code: 'requires-recent-login', message: 'Please log in again'),
    'operation-not-allowed': AuthAppException(
        code: 'operation-not-allowed',
        message: 'This sign-in method is not available'),
    'account-exists-with-different-credential': AuthAppException(
        code: 'account-exists-with-different-credential',
        message: 'Email already used with another login method'),
  };

  @override
  bool canHandle() {
    return _errorFactories.containsKey((error as FirebaseException).code);
  }

  @override
  AppException? handle() {
    if (canHandle()) {
      return _errorFactories[(error as FirebaseException).code];
    }
    return FirebaseAppException(message: 'Firebase error');
  }
}


class AuthAppException extends FirebaseAppException {
  AuthAppException({
    super.code,
    required super.message
  });
}


class FirestoreAppException extends FirebaseAppException {
  FirestoreAppException({
    super.code,
    required super.message
  });
}


class StorageAppException extends FirebaseAppException {
  StorageAppException({
    super.code,
    required super.message
  });
}