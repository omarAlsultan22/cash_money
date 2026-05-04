import 'package:flutter/material.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import '../../../../features/auth/presentation/screens/sign_in_screen.dart';


class BuildNavigator {
  static void build({
    Widget? link,
    required BuildContext context,
  }) {
    Future.delayed(const Duration(seconds: AppDurations.oneSecond), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => link ?? const SignInScreen()
        ),
      );
    });
  }
}