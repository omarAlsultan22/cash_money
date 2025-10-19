import '../../shared/components/constatnts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/settings_layout.dart';
import 'package:flutter/material.dart';
import 'cubit.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppModelCubit()..getInfo(UserDetails.uId),
      child: const SettingsLayout(),
    );
  }
}