import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../domain/repositories/settings_repository.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import '../../../../core/data/data_sources/local/cache_helper.dart';


class FirebaseSettingsRepository implements SettingsRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;
  String? _cachedUserId;

  FirebaseSettingsRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  Future<String> _getUserId() async {
    if (_cachedUserId != null) return _cachedUserId!;
    _cachedUserId = await _cacheHelper.getString(key: AppKeys.uId);
    return _cachedUserId!;
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async {
    try {
      final userId = await _getUserId();
      final jsonData = await _repository.getDocument(
          docId: userId,
          collectionPath: AppKeys.users
      );
      return jsonData;
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
      final userId = await _getUserId();

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