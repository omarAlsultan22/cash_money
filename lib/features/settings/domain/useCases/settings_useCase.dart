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
      return await _repository.getInfo();
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
      return await _repository.updateInfo(
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

