import 'package:firebase_auth/firebase_auth.dart';
import 'package:cash_money/core/domain/data_sources/auth_service.dart';


class FakeAuthService implements AuthService {
  // ما يعيده signIn
  UserCredential? signInResult;
  Object? signInError;

  // ما يعيده signUp
  UserCredential? signUpResult;
  Object? signUpError;

  // ما يعيده updateProfile
  User? updateProfileResult;
  Object? updateProfileError;

  // أخطاء sendPasswordResetEmail
  Object? sendResetEmailError;

  // تسجيل الاستدعاءات
  int signInCallCount = 0;
  String? lastSignInEmail;
  String? lastSignInPassword;

  int signUpCallCount = 0;
  int sendResetEmailCallCount = 0;
  String? lastResetEmail;
  ActionCodeSettings? lastActionCodeSettings;

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    signInCallCount++;
    lastSignInEmail = email;
    lastSignInPassword = password;
    if (signInError != null) throw signInError!;
    return signInResult!;
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    signUpCallCount++;
    if (signUpError != null) throw signUpError!;
    return signUpResult!;
  }

  @override
  Future<User?> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (updateProfileError != null) throw updateProfileError!;
    return updateProfileResult;
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String userEmail,
    required ActionCodeSettings actionCodeSettings,
  }) async {
    sendResetEmailCallCount++;
    lastResetEmail = userEmail;
    lastActionCodeSettings = actionCodeSettings;
    if (sendResetEmailError != null) throw sendResetEmailError!;
  }
}