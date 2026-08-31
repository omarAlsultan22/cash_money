import '../repositories/auth_repository.dart';
import 'package:cash_money/core/services/session_service.dart';


class SignInUseCase {
  final SessionService _sessionService;
  final AuthRepository _authRepository;

  SignInUseCase({
    required SessionService sessionService,
    required AuthRepository authRepository
  })
      :
        _sessionService = sessionService,
        _authRepository = authRepository;

  Future<void> execute({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      final userCredential = await _authRepository.signIn(
          userEmail: userEmail,
          userPassword: userPassword
      );

      await _sessionService.login(userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }
}

