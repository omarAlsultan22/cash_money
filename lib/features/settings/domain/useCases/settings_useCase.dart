import '../repositories/settings_repository.dart';
import '../../../../core/data/models/user_model.dart';


class SettingsUseCase {
  final SettingsRepository _repository;

  SettingsUseCase({
    required SettingsRepository repository,
  })
      :_repository = repository;

  Future<UserModel> getInfoExecute() async {
    try {
      return await _repository.getUserInfo();
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> updateInfoExecute({
    required String userName,
    required String userPhone,
    required String userLocation
  }) async {
    try {
      await _repository.updateUserInfo(
          userName: userName,
          userPhone: userPhone,
          userLocation: userLocation
      );
    }
    catch (e) {
      rethrow;
    }
  }
}

