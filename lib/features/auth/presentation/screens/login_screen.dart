import 'package:cash_money/features/auth/presentation/cubits/auth_operations.dart';

import '../../../user_info/data/repositories_impl/firestore_user_info_repository.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/useCases/auth_useCase.dart';
import '../widgets/layouts/login_layout.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final repository = FirebaseFirestore.instance;
    final authRepository = FirebaseAuthRepository(auth: auth);
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final authUseCase = AuthUseCase(
        authRepository: authRepository, userInfoRepository: userInfoRepository);
    final authOperations = AuthOperations(authUseCase: authUseCase);
    return LoginLayout(authOperations);
  }
}