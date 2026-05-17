import 'network_app_exception.dart';
import 'base/app_exception.dart';
import 'base/app_exception_convertible.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class FirebaseAppException extends AppException implements AppExceptionConvertible {
  FirebaseAppException({
    super.error,
    super.message
  });

  static final connectivityService = ConnectivityService();
  static const String _msgNoInternet = 'No Internet Connection';

  Map<String, AppException> map = {
    'unavailable': NetworkAppException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'network-error': NetworkAppException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'network-request-failed': NetworkAppException(
        message: _msgNoInternet,
        connectivityService: connectivityService),
    'permission-denied': FirebaseAppException(
        message: 'You do not have permission to access'),
    'not-found': FirebaseAppException(message: 'Data not found'),
    'already-exists': FirebaseAppException(message: 'Data already exists'),
    'user-not-found': FirebaseAppException(
        message: 'No user registered with this email'),
    'invalid-email': FirebaseAppException(message: 'Invalid email address'),
    'wrong-password': FirebaseAppException(message: 'Wrong password'),
    'email-already-in-use': FirebaseAppException(
        message: 'Email already in use'),
    'weak-password': FirebaseAppException(message: 'Weak password'),
    'user-disabled': FirebaseAppException(message: 'User account is disabled'),
    'too-many-requests': FirebaseAppException(
        message: 'Too many requests, try again later'),
    'invalid-credential': FirebaseAppException(
        message: 'Invalid login credentials'),
    'requires-recent-login': FirebaseAppException(
        message: 'Please log in again'),
    'unauthenticated': FirebaseAppException(
        message: 'User is not authenticated'),
    'failed-precondition': FirebaseAppException(message: 'Failed precondition'),
  };


  @override
  AppException getException() {
    final isKeyFound = map.containsKey(error.code);
    if (isKeyFound) {
      final value = map[error.code];
      if (value != null) {
        return value;
      }
    }
    return FirebaseAppException(message: 'Firebase error');
  }
}