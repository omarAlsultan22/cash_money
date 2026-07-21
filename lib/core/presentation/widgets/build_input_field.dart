import 'package:cash_money/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class BuildInputField extends StatelessWidget {
  bool obscureText;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final InputDecoration? decoration;
  final List<String>? autofillHints;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? Function(dynamic value) validator;

  BuildInputField({
    super.key,
    this.hintText,
    this.helperText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.decoration,
    this.autofillHints,
    this.keyboardType,
    this.obscureText = false,
    required this.controller,
    required this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: AppColors.amber_500,
      cursorRadius: const Radius.circular(100.0),
      autofillHints: autofillHints,
      validator: validator,
      decoration: decoration ?? InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        helperText: helperText,
        fillColor: AppColors.brown_700.withOpacity(0.5),
        labelStyle: const TextStyle(color: AppColors.amber_500),
        prefixIcon: Icon(prefixIcon, color: AppColors.amber_500),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}