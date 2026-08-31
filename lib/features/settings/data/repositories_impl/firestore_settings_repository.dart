import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../domain/repositories/settings_repository.dart';
import 'package:cash_money/core/services/session_service.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';


class FirebaseSettingsRepository implements SettingsRepository {
  final FirestoreService _repository;
  final SessionService _sessionService;

  FirebaseSettingsRepository({
    required FirestoreService repository,
    required SessionService sessionService
  })
      : _repository = repository,
        _sessionService = sessionService;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async {
    try {
      final jsonData = await _repository.getDocument(
          docId: _sessionService.currentUid,
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
      final userModel = UserModel(
        userName: userName,
      );
      await _repository.updateDocument(
          docId: _sessionService.currentUid,
          collectionPath: AppKeys.users,
          data: userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}