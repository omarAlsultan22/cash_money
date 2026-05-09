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
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        filled: true,
        fillColor: AppColors.brown_700.withOpacity(0.5),
        labelStyle: const TextStyle(color: AppColors.amber_500),
        prefixIcon: Icon(prefixIcon, color: AppColors.amber_500),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}