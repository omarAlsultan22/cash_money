import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'base/app_exception.dart';
import 'network_exception.dart';


class FirebaseAppException extends AppException {
  FirebaseAppException({
    super.error,
  });

  static final connectivityService = ConnectivityService();

  Map<String, AppException> map = {
    'unavailable': NetworkException(
        message: 'No Internet Connection',
        connectivityService: connectivityService),
    'network-error': NetworkException(
        message: 'No Internet Connection',
        connectivityService: connectivityService),
    'network-request-failed': NetworkException(
        message: 'No Internet Connection',
        connectivityService: connectivityService),
    'permission-denied': FirebaseAppException(
        error: 'You do not have permission to access'),
    'not-found': FirebaseAppException(error: 'Data not found'),
    'already-exists': FirebaseAppException(error: 'Data already exists'),
    'user-not-found': FirebaseAppException(
        error: 'No user registered with this email'),
    'invalid-email': FirebaseAppException(error: 'Invalid email address'),
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
    return FirebaseAppException(error: 'Firebase error');
  }
}