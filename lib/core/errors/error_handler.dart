import 'package:cash_money/core/errors/exceptions/firebase_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/server_exception.dart';
import 'exceptions/app_exception.dart';


class ErrorHandler {
  static AppException handleException(AppException exception) {
    if (exception is NoInternetException) {
      return const NoInternetException('No Internet Connection', true);
    }
    if (exception is FirebaseAuthException) {
      return FirebaseAuthException(exception.message, false);
    }
    return ServerException(exception.message, false);
  }
}
