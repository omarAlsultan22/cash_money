import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthService {
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<UserCredential> signUp({
    required String email,
    required String password
  });

  Future<User?> updateProfile({
    required String newEmail,
    required String newPassword,
    required String currentPassword,
  });

  Future<void> sendPasswordResetEmail({
    required String userEmail,
    required ActionCodeSettings actionCodeSettings
  });
}