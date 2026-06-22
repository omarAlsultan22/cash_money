import '../../../../core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../domain/repositories/settings_repository.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class FirebaseSignUpRepository implements SettingsRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;

  FirebaseSignUpRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final docId = await _cacheHelper.getValue(key: AppKeys.uId);
      print(docId);
      final jsonData = await _repository.getDocument(
          docId: docId,
          collectionPath: AppKeys.users);
      print("info is ${jsonData.data()}");
      return UserModel.fromDocumentSnapshot(jsonData);
    }
    catch (e) {

    rethrow;
    }
  }

  @override
  Future<void> updateUserInfo({
    required String userName,
  }) async {
    try {
      final userId = await _cacheHelper.getValue(key: AppKeys.uId);

      final userModel = UserModel(
        userName: userName,
      );
      await _repository.updateDocument(
          docId: userId,
          collectionPath: AppKeys.users,
          data: userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}