import '../../../constants/app_durations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cash_money/core/domain/services/auth_service.dart';


class AuthServiceImpl implements AuthService{
  static final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).timeout(AppDurations.seconds);
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).timeout(AppDurations.seconds);
  }

  @override
  Future<User?> updateProfile({
    required String newEmail,
    required String newPassword,
    required String currentPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String userEmail,
    required ActionCodeSettings actionCodeSettings
  }) async {
    await _firebaseAuth.sendSignInLinkToEmail(
        email: userEmail, actionCodeSettings: actionCodeSettings).timeout(
        AppDurations.seconds);
  }
}