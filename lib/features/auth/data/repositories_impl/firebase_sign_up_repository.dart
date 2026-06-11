import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_keys.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:cash_money/features/auth/domain/repositories/sign_up_repository.dart';


class FirebaseSignUpRepository implements SignUpRepository {
  final FirestoreService _repository;

  FirebaseSignUpRepository({
    required FirestoreService repository
  }) : _repository = repository;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    try {
      await _repository.setData(
          collectionPath: AppKeys.users,
          docId: userCredential.user!.uid,
          data: userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }
}