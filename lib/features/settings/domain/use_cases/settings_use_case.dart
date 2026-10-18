import '../repositories/settings_repository.dart';
import '../../../../core/data/models/user_model.dart';


class SettingsUseCase {
  final SettingsRepository _repository;

  SettingsUseCase({
    required SettingsRepository repository,
  })
      :_repository = repository;

  Future<UserModel> getInfoExecute() async {
    final jsonData = await _repository.getUserInfo();
    final docData = jsonData.data() as Map<String, dynamic>;
    return UserModel.fromDocumentSnapshot(docData);
  }

  Future<void> updateInfoExecute({
    required String? userName,
  }) async {
    await _repository.updateUserInfo(
      userName: userName,
    );
  }
}

