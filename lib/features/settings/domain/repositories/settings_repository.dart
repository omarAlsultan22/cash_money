import '../../../../core/data/models/user_model.dart';


abstract class SettingsRepository {
  Future<UserModel> getUserInfo();

  Future<void> updateUserInfo({
    required String userName,
  });
}