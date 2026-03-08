import 'package:provider/provider.dart';

import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/screen/connectivity_aware_service.dart';
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
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareService(
              isConnected: connectivityProvider.isConnected,
              child: LoginLayout(authOperations)
          );
        }
    );
  }
}
