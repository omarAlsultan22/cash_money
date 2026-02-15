import 'package:cash_money/core/errors/exceptions/app_exception.dart';


class FirebaseAuthException extends AppException{
  FirebaseAuthException(super.message, super.isConnectionError);
}