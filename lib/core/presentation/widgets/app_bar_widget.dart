import 'icon_button_widget.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';


class AppBarWidget {
  static PreferredSizeWidget build() {
    return AppBar(
        leading: const IconButtonWidget(),
        backgroundColor: AppColors.transparent
    );
  }
}
