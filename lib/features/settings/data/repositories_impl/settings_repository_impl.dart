import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../domain/repositories/settings_repository.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../../../../core/domain/data_sources/firestore_service.dart';


class SettingsRepositoryImpl implements SettingsRepository {
  final FirestoreService _dataSource;
  final SessionService _sessionService;

  SettingsRepositoryImpl({
    required FirestoreService dataSource,
    required SessionService sessionService
  })
      : _dataSource = dataSource,
        _sessionService = sessionService;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async {
    final jsonData = await _dataSource.getDocument(
        docId: _sessionService.currentUid,
        collectionPath: AppKeys.users
    );
    return jsonData;
  }

  @override
  Future<void> updateUserInfo({
    required String? userName,
  }) async {
    final userModel = UserModel(
      userName: userName,
    );
    await _dataSource.updateDocument(
        docId: _sessionService.currentUid,
        collectionPath: AppKeys.users,
        data: userModel.toJson());
  }
}