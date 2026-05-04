import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';


class FirestoreSettingsRepository implements SettingsRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;

  FirestoreSettingsRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  static const uId = AppKeys.uId;
  static const users = AppKeys.users;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      await _repository.setData(
          collectionPath: users,
          docId: userCredential.user!.uid,
          data: userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final userId = await _cacheHelper.getValue(key: uId);
      final jsonData = await _repository.getDocument(
          docId: userId,
          collectionPath: users);
      return UserModel.fromDocumentSnapshot(jsonData);
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserInfo({
    required String userName,
    required String userPhone,
    required String userLocation
  }) async {
    try {
      final userId = await _cacheHelper.getValue(key: uId);

      final userModel = UserModel(
          userName: userName,
          userPhone: userPhone,
          userLocation: userLocation,
          isEmailVerified: false
      );
      await _repository.updateDocument(
          docId: userId,
          collectionPath: users,
          data: userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}