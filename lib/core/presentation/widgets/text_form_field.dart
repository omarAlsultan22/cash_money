import 'package:flutter/material.dart';


Widget buildInputField({
  String? labelText,
  Widget? suffixIcon,
  bool obscureText = false,
  List<String>? autofillHints,
  TextInputType? keyboardType,
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
  required String? Function(dynamic value) validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    cursorColor: Colors.amber,
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
      fillColor: Colors.brown[700]!.withOpacity(0.5),
      labelStyle: const TextStyle(color: Colors.amber),
      prefixIcon: Icon(prefixIcon, color: Colors.amber),
      suffixIcon: suffixIcon,
    ),
    style: const TextStyle(color: Colors.white),
  );
}