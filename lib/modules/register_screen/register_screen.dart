import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/register_layout.dart';
import 'package:flutter/material.dart';
import 'cubit.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterLayout(),
    );
  }
}