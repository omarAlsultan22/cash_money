import '../../layout/change_email_and_password_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'cubit.dart';


class ChangeEmailAndPasswordScreen extends StatelessWidget {
  const ChangeEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppModelCubit(),
      child: const ChangeEmailAndPasswordLayout(),
    );
  }
}