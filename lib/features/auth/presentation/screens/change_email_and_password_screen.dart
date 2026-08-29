import 'package:cash_money/core/data/data_sources/local/cache_helper.dart';
import 'package:cash_money/features/auth/presentation/states/auth_states.dart';
import '../widgets/layouts/change_email_and_password_layout.dart';
import '../cubits/change_email_and_password_cubit.dart';
import '../../../../core/di/service _locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangeEmailAndPasswordCubit>(
        create: (context) =>
            sl<ChangeEmailAndPasswordCubit>(),
        child: BlocBuilder<ChangeEmailAndPasswordCubit, AuthState>(
            builder: (context, state) {
              final cubit = ChangeEmailAndPasswordCubit.get(context);
              return ChangeEmailAndPasswordLayout(
                  cacheHelper: sl<CacheHelper>(),
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