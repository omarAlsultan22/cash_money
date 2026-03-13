import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/screen/connectivity_aware_service.dart';
import '../../../settings/data/repositories_impl/settings_repository.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/useCases/auth_useCase.dart';
import '../widgets/layouts/register_layout.dart';
import '../services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final repository = FirebaseFirestore.instance;
    final authRepository = FirebaseAuthRepository(auth: auth);
    final settingsRepository = FirestoreSettingsRepository(
        repository: repository);
    final authUseCase = AuthUseCase(
        authRepository: authRepository, settingsRepository: settingsRepository);
    final authServices = AuthServices(authUseCase: authUseCase);
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareService(
              isConnected: connectivityProvider.isConnected,
              child: RegisterLayout(authServices)
          );
        }
    );
  }
}