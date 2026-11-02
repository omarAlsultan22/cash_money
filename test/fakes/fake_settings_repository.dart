import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/features/settings/domain/repositories/settings_repository.dart';


/// Fake مخصص لـ SettingsUseCase.
/// يغطي فقط getUserInfo و updateUserInfo (اللتان يستخدمهما SettingsUseCase).
class FakeSettingsRepository implements SettingsRepository {
  // ===== getUserInfo =====
  DocumentSnapshot<Map<String, dynamic>>? userInfoResult;
  Object? getUserInfoError;
  int getUserInfoCallCount = 0;

  // ===== updateUserInfo =====
  int updateUserInfoCallCount = 0;
  String? lastUserName;
  Object? updateUserInfoError;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async {
    getUserInfoCallCount++;
    if (getUserInfoError != null) throw getUserInfoError!;
    return userInfoResult!;
  }

  @override
  Future<void> updateUserInfo({required String? userName}) async {
    updateUserInfoCallCount++;
    lastUserName = userName;
    if (updateUserInfoError != null) throw updateUserInfoError!;
  }
}