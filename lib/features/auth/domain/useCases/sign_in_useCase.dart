import '../repositories/auth_repository.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class SignInUseCase {
  final CacheHelper _cacheHelper;
  final AuthRepository _authRepository;

  SignInUseCase({
    required CacheHelper cacheHelper,
    required AuthRepository authRepository
  })
      :
        _cacheHelper = cacheHelper,
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
      _cacheHelper.setString(key: AppKeys.uId, value: userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }
}

