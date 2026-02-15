import 'package:flutter/material.dart';


Widget buildInputField({
  String? label,
  Widget? suffixIcon,
  bool obscureText = false,
  List<String>? autofillHints,
  TextInputType? keyboardType,
  required TextEditingController controller,
  required String hint,
  required IconData icon,
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
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: label,
      filled: true,
      fillColor: Colors.brown[700]!.withOpacity(0.5),
      labelStyle: const TextStyle(color: Colors.amber),
      prefixIcon: Icon(icon, color: Colors.amber),
      suffixIcon: suffixIcon,
    ),
    style: const TextStyle(color: Colors.white),
  );
}