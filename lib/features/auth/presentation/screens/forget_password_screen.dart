import 'package:cash_money/features/auth/presentation/widgets/layouts/forget_password_layout.dart';
import 'package:cash_money/features/auth/presentation/cubits/forget_password_cubit.dart';
import '../../../../core/data/network/connectivity_service.dart';
import '../../../../core/data/data_sources/remote/firebase_auth.dart';
import '../../data/repositories_impl/firebase_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../states/auth_states.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();
    final authRepository = FirebaseAuthRepository(auth: auth);
    final connectivityService = ConnectivityService();
    return BlocProvider<ForgetPasswordCubit>(
        create: (context) =>
            ForgetPasswordCubit(repository: authRepository,
                connectivityService: connectivityService),
        child: BlocBuilder<ForgetPasswordCubit, AuthState>(
            builder: (context, state) {
              final cubit = ForgetPasswordCubit.get(context);
              return ForgetPasswordLayout(
                  messageResult: state.messageResult!,
                  onUpdate: ({
                    required String userEmail,
                  }) =>
                      cubit.sendResetEmail(
                          userEmail: userEmail
                      )
              );
            }
        )
    );
  }
}
