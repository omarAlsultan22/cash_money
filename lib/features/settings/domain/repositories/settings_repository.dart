import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_model.dart';


abstract class SettingsRepository {
  Future<void> setInfo({
    required UserModel userModel,
    required UserCredential userCredential
  });

  Future<UserModel> getInfo();

  Future<void> updateInfo({
    required String userName,
    required String userPhone,
    required String userLocation
  });
}