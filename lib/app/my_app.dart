import 'package:flutter/material.dart';
import '../core/di/service _locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cash_money/features/questions/presentation/cubits/data_cubit.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataCubit>(create: (context) =>
        sl<DataCubit>(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
      ),
    );
  }
}