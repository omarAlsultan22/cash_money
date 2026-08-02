import 'package:cash_money/features/auth/domain/useCases/change_email_and_password_useCase.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/auth/presentation/states/auth_states.dart';
import 'package:cash_money/core/data/data_sources/remote/firebase_auth.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../widgets/layouts/change_email_and_password_layout.dart';
import '../../../../core/services/connectivity_service.dart';
import '../cubits/change_email_and_password_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheHelper = CacheHelper();
    final auth = FirebaseAuthService();
    final authRepository = FirebaseAuthRepository(auth: auth);
    final useCase = ChangeEmailAndPasswordUseCase(
        authRepository: authRepository);
    final connectivityService = ConnectivityService();
    return BlocProvider<ChangeEmailAndPasswordCubit>(
        create: (context) =>
            ChangeEmailAndPasswordCubit(
                useCase: useCase, connectivityService: connectivityService),
        child: BlocBuilder<ChangeEmailAndPasswordCubit, AuthState>(
            builder: (context, state) {
              final cubit = ChangeEmailAndPasswordCubit.get(context);
              return ChangeEmailAndPasswordLayout(
                  cacheHelper: cacheHelper,
                  messageResult: state.messageResult!,
                  onUpdate: ({
                    required String newEmail,
                    required String currentPassword,
                    required String newPassword
                  }) =>
                      cubit.changeEmailAndPassword(
                          newEmail: newEmail,
                          currentPassword: currentPassword,
                          newPassword: newPassword
                      )
              );
            }
        )
    );
  }
}