import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'base/app_exception.dart';
import 'network_exception.dart';


class AppFirebaseException extends AppException {
  AppFirebaseException({
    super.error,
  });

  static final connectivityService = ConnectivityService();

  Map<String, AppException> map = {
    'unavailable': AppNetworkException(
        message: 'No Internet Connection',
        connectivityService: connectivityService),
    'network-error': AppNetworkException(
        message: 'No Internet Connection',
        connectivityService: connectivityService),
    'network-request-failed': AppNetworkException(
        message: 'No Internet Connection',
        connectivityService: connectivityService),
    'permission-denied': AppFirebaseException(
        error: 'You do not have permission to access'),
    'not-found': AppFirebaseException(error: 'Data not found'),
    'already-exists': AppFirebaseException(error: 'Data already exists'),
    'user-not-found': AppFirebaseException(
        error: 'No user registered with this email'),
    'invalid-email': AppFirebaseException(error: 'Invalid email address'),
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
    return AppFirebaseException(error: 'Firebase error');
  }
}