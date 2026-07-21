import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';


class ForgetPasswordUseCase {
  final AuthRepository _authRepository;

  ForgetPasswordUseCase({
    required AuthRepository authRepository
  })
      :
        _authRepository = authRepository;

  Future<void> execute({
    required String userEmail,
  }) async {
    try {
      const String authDomain = 'cachmoney-8f3b8.firebaseapp.com';
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://$authDomain/verify',
        // استخدم نطاقك
        handleCodeInApp: true,
        androidPackageName: 'com.example.cash_money',
        // اسم حزمة تطبيقك
        iOSBundleId: 'com.example.cash_money',
        // معرف تطبيقك في iOS
        linkDomain: authDomain, // نطاقك
      );
      await _authRepository.sendPasswordResetEmail(
          userEmail: userEmail,
          actionCodeSettings: actionCodeSettings
      );
    } catch (e) {
      rethrow;
    }
  }
}