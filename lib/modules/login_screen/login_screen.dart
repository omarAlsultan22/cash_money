import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/login_layout.dart';
import 'package:flutter/material.dart';
import 'cubit.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginLayout(),
    );
  }
}