import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/navigation/navigator_with_delay.dart';
import '../../../../core/data/models/message_result.dart';
import 'package:cash_money/core/presentation/utils/ui_utils.dart';


mixin AuthMixin<T extends StatefulWidget> on State<T> {

  void handleMessageResult({
    required MessageResult messageResult,
    required VoidCallback onNavigate,
    VoidCallback? onClear,
  }) {
    if (messageResult.message != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        UiUtils.showMessageResult(
            context: context, messageResult: messageResult);
      });
      if (messageResult.error == null) {
        onClear?.call();
        onNavigate();
      }
      setState(() {});
    }
  }

  Widget buildPasswordVisibilityToggle({
    required bool isObscure,
    required VoidCallback onToggle,
    Color iconColor = AppColors.amber_500,
  }) {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off : Icons.visibility,
        color: iconColor,
      ),
      onPressed: onToggle,
    );
  }

  void navigateToScreen(Widget link) {
    NavigatorWithDelay.build(link: link, context: context);
  }
}