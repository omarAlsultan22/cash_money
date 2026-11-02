import '../repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChangeEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  ChangeEmailAndPasswordUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<void> execute({
    required String newEmail,
    required String newPassword,
    required String currentPassword,
  }) async {
    final user = await _authRepository.updateProfile(
      newEmail: newEmail,
      newPassword: newPassword,
      currentPassword: currentPassword,
    );

    if (user == null) return;

    final email = user.email;
    if (email == null) {
      throw Exception('User email is null');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.verifyBeforeUpdateEmail(newEmail);
    await user.updatePassword(newPassword);
  }
}