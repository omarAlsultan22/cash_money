import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_keys.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import '../../../../core/domain/services/firestore_service.dart';
import 'package:cash_money/features/auth/domain/repositories/sign_up_repository.dart';


class SignUpRepositoryImpl implements SignUpRepository {
  final FirestoreService _repository;

  SignUpRepositoryImpl({
    required FirestoreService repository
  }) : _repository = repository;

  @override
  Future<void> createUserInfo({
    required UserModel userModel,
    required UserCredential userCredential
  }) async {
    await _repository.setData(
        collectionPath: AppKeys.users,
        docId: userCredential.user!.uid,
        data: userModel.toJson());
  }
}