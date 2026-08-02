import 'package:cash_money/features/auth/data/repositories_impl/firebase_sign_up_repository.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/auth/presentation/cubits/sign_up_cubit.dart';
import 'package:cash_money/features/auth/domain/useCases/sign_up_useCase.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import '../../../../core/data/data_sources/remote/firebase_auth.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import '../../../../core/services/connectivity_service.dart';
import '../widgets/layouts/sign_up_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../states/auth_states.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();
    final repository = FirestoreService();
    final cacheHelper = CacheHelper();
    final authRepository = FirebaseAuthRepository(auth: auth);
    final signUpRepository = FirebaseSignUpRepository(repository: repository);
    final useCase = SignUpUseCase(
        cacheHelper: cacheHelper,
        authRepository: authRepository,
        signUpRepository: signUpRepository
    );
    final connectivityService = ConnectivityService();
    return BlocProvider<SignUpCubit>(
        create: (context) =>
            SignUpCubit(
                useCase: useCase, connectivityService: connectivityService),
        child: BlocBuilder<SignUpCubit, AuthState>(
            builder: (context, state) {
              final cubit = SignUpCubit.get(context);
              return SignUpLayout(
                  messageResult: state.messageResult!,
                  onUpdate: ({
                    required String userName,
                    required String userEmail,
                    required String userPassword,
                  }) =>
                      cubit.signUp(
                        userName: userName,
                        userEmail: userEmail,
                        userPassword: userPassword,
                      )
              );
            }
        )
    );
  }
}