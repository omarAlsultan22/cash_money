import 'package:flutter/material.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/build_snack_bar.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_paddings.dart';
import '../../data/models/message_result.dart';
import '../widgets/loading_widget.dart';


class UiUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void showMessageResult({
    required BuildContext context,
    required MessageResult messageResult,
  }) {
    BuildSnackBar.show(
        context: context,
        message: messageResult.message!,
        backgroundColor: messageResult.color!
    );
  }

  static Widget buildButtonContent({
    required bool isLoading,
    required String text,
    bool isSaveButton = false,
  }) {
    if (isLoading) {
      return isSaveButton
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: AppColors.white,
        ),
      )
          : LoadingWidget.sizedBox;
    }

    return Text(
      text,
      style: AppTextStyles.textStyle,
    );
  }

  static ButtonStyle buttonStyle({EdgeInsetsGeometry? padding}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.amber_500,
      foregroundColor: AppColors.black,
      padding: padding ?? AppPaddings.verticalSymmetric,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2.0,
    );
  }
}