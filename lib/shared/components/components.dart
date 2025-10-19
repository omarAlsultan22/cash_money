import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../cubit/state.dart';


Widget sizeBox() =>
    const SizedBox(
      height: 16.0,
    );


void statesListener(BuildContext context, AppDataStates state) {
  if (state is AppDataErrorState && state.key != Screens.questions) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.error!),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.red[800],
      ),
    );
  }
}


void showToast(msg) {
  Fluttertoast.showToast(
      msg: msg??'Sorry the Email or Password not correct',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.yellow
  );
}


@override
Widget button(BuildContext context, Icon icon) =>
     AppBar(
        backgroundColor: Colors.brown[900],
        leading: IconButton(
          splashColor: Colors.amber,
          onPressed: () {
            Navigator.pop(context);
          }, icon: icon));


String? validateInput(String value, String fieldName, {String? newPassword}) {
  if (value.isEmpty) {
    return 'يرجي أدخال $fieldName';
  }
  if (fieldName == 'email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'يرجي أدخال الايميل الصحيح';
  }
  if (fieldName == 'new password again' && value != newPassword) {
    return 'كلمتان المرور غير متطابقتان';
  }
  return null;
}


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


