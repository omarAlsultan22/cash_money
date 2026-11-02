import '../../../constants/app_durations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/data_sources/auth_service.dart';


class AuthServiceImpl implements AuthService{
  final FirebaseAuth _firebaseAuth;
  static const _duration = AppDurations.seconds;

  AuthServiceImpl({FirebaseAuth? auth})
      : _firebaseAuth = auth ?? FirebaseAuth.instance;
  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).timeout(_duration);
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).timeout(_duration);
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
        _duration);
  }
}