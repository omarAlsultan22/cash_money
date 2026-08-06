import 'package:cloud_firestore/cloud_firestore.dart';


abstract class SettingsRepository {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo();

  Future<void> updateUserInfo({required String userName});
}