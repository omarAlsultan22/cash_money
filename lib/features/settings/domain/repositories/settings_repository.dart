import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_model.dart';


abstract class SettingsRepository {
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  });

  Future<UserModel> getUserInfo();

  Future<void> updateUserInfo({
    required String userName,
    required String userPhone,
    required String userLocation
  });
}