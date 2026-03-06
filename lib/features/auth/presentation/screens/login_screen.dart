import '../../data/repositories_impl/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/useCases/auth_useCase.dart';
import '../widgets/layouts/login_layout.dart';
import '../operations/auth_operations.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final authRepository = FirebaseAuthRepository(auth: auth);
    final authUseCase = AuthUseCase(
        authRepository: authRepository);
    final authOperations = AuthOperations(authUseCase: authUseCase);
    return LoginLayout(authOperations);
  }
}