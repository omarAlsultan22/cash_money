import 'package:cash_money/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class BuildInputField extends StatelessWidget {
  final String? labelText;
  final Widget? suffixIcon;
  bool obscureText = false;
  final List<String>? autofillHints;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(dynamic value) validator;

  BuildInputField({
    this.labelText,
    this.suffixIcon,
    this.obscureText = false,
    this.autofillHints,
    this.keyboardType,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.validator
  });

  static const _white = AppColors.white;
  static const _amber = AppColors.amber_500;
  static const _cursorRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: _amber,
      cursorRadius: const Radius.circular(_cursorRadius),
      autofillHints: autofillHints,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _white),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        filled: true,
        fillColor: AppColors.brown_700.withOpacity(0.5),
        labelStyle: const TextStyle(color: _amber),
        prefixIcon: Icon(prefixIcon, color: _amber),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: _white),
    );
  }
}