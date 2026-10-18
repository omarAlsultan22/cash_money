import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/domain/services/auth_service.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthService _auth;

  AuthRepositoryImpl({required AuthService auth}) : _auth = auth;

  @override
  Future<UserCredential> signIn({
    required String userEmail,
    required String userPassword
  }) async {
    try {
      final userCredential = await _auth.signIn(
        email: userEmail,
        password: userPassword,
      );
      if (userCredential.user == null) {
        throw();
      }
      return userCredential;
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signUp({
    required String userEmail,
    required String userPassword
  }) async {
    try {
      return await _auth
          .signUp(
          email: userEmail,
          password: userPassword
      ).then((value) {
        return value;
      });
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> updateProfile({
    required String newEmail,
    required String currentPassword,
    required String newPassword
  }) async {
    try {
      final user = await _auth.updateProfile(
          newEmail: newEmail,
          currentPassword: currentPassword,
          newPassword: newPassword);
      return user;
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String userEmail,
    required ActionCodeSettings actionCodeSettings
  }) async {
    await _auth.sendPasswordResetEmail(
        userEmail: userEmail,
        actionCodeSettings: actionCodeSettings
    );
  }
}