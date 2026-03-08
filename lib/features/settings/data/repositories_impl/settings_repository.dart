import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/settings_repository.dart';
import 'package:cash_money/core/constants/app_texts.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class FirestoreSettingsRepository implements SettingsRepository {
  final FirebaseFirestore _repository;

  FirestoreSettingsRepository({required FirebaseFirestore repository})
      : _repository = repository;

  static const uId = AppTexts.uId;
  static const users = AppTexts.users;

  @override
  Future<void> setInfo({
    required UserModel userModel,
    required UserCredential userCredential
}) async {
    try {
      await _repository.collection(users).doc(userCredential.user!.uid).set(
          userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getInfo() async {
    try {
      final userId = await CacheHelper.getValue(key: uId);
      final jsonData = await _repository.collection(users).doc(
          userId).get();
      return UserModel.fromDocumentSnapshot(jsonData);
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateInfo({
    required String userName,
    required String userPhone,
    required String userLocation
  }) async {
    try {
      final userId = await CacheHelper.getValue(key: uId);

      final userModel = UserModel(
          userName: userName,
          userPhone: userPhone,
          userLocation: userLocation,
          isEmailVerified: false
      );
      await _repository.collection(users).doc(userId).update(userModel.toJson());
    }
    catch (e) {
      rethrow;
    }
  }
}