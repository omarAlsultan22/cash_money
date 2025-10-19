import 'package:cash_money/shared/local/shared_preferences.dart';
import 'package:cash_money/shared/components/components.dart';
import '../modules/login_screen/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/sttings_screen/cubit.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/state.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  const ChangeEmailAndPasswordLayout({super.key});

  @override
  State<ChangeEmailAndPasswordLayout> createState() => _ChangeEmailAndPasswordLayoutState();
}

class _ChangeEmailAndPasswordLayoutState extends State<ChangeEmailAndPasswordLayout> {
  final formKey = GlobalKey<FormState>();
  final newEmailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatNewPasswordController = TextEditingController();

  bool isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    newEmailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppModelCubit, AppDataStates>(
      builder: (context, state) => _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final cubit = AppModelCubit.get(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.brown[900],
        appBar: _buildAppBar(cubit),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(AppModelCubit cubit) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildBackButton(),
      title: const Text(
        'تغيير البريد وكلمة المرور',
        style: TextStyle(color: Colors.white),
      ),
      actions: [_buildSaveButton(cubit)],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: _isLoading ? null : () => Navigator.pop(context),
    );
  }

  Widget _buildSaveButton(AppModelCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: _saveButtonStyle(),
        onPressed: _isLoading ? null : () => _onSavePressed(cubit),
        child: _buildSaveButtonContent(),
      ),
    );
  }

  Widget _buildSaveButtonContent() {
    return _isLoading
        ? const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    )
        : const Text(
      'حفظ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    return IgnorePointer(
      ignoring: _isLoading,
      child: Container(
        decoration: _buildBackgroundDecoration(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildEmailField(),
                  sizeBox(),
                  _buildCurrentPasswordField(),
                  sizeBox(),
                  _buildNewPasswordField(),
                  sizeBox(),
                  _buildConfirmPasswordField(),
                  if (_isLoading) _buildLoadingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return buildInputField(
      controller: newEmailController,
      hint: "البريد الإلكتروني الجديد",
      icon: Icons.email,
      validator: (value) => _validateInput(value, 'البريد الإلكتروني'),
    );
  }

  Widget _buildCurrentPasswordField() {
    return buildInputField(
      controller: currentPasswordController,
      hint: "كلمة المرور الحالية",
      icon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value, 'كلمة المرور الحالية'),
    );
  }

  Widget _buildNewPasswordField() {
    return buildInputField(
      controller: newPasswordController,
      hint: "كلمة المرور الجديدة",
      icon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value, 'كلمة المرور الجديدة'),
    );
  }

  Widget _buildConfirmPasswordField() {
    return buildInputField(
      controller: repeatNewPasswordController,
      hint: "تأكيد كلمة المرور الجديدة",
      icon: Icons.lock_reset,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: _validatePasswordConfirmation,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        SizedBox(height: 24),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
      ],
    );
  }

  IconButton _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.amber[700],
      ),
      onPressed: () => setState(() => isObscure = !isObscure),
    );
  }

  Future<void> _onSavePressed(AppModelCubit cubit) async {
    if (!_validateForm()) return;
    await _saveChanges(cubit);
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (newPasswordController.text != repeatNewPasswordController.text) {
      _showPasswordMismatchError();
      return false;
    }

    return true;
  }

  Future<void> _saveChanges(AppModelCubit cubit) async {
    setState(() => _isLoading = true);

    try {
      await cubit.changeEmailAndPassword(
        newEmail: newEmailController.text,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      ).then((_) {
        _clearUserData();
      }).whenComplete(() {
        _navigateToLogin();
      });
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearUserData() {
    CacheHelper.removeData(key: 'uId');
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  String? _validatePasswordConfirmation(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != newPasswordController.text) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  void _showPasswordMismatchError() {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('كلمة المرور الجديدة غير متطابقة', Colors.red[800]!),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('فشل التحديث: $error', Colors.red[800]!),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.brown[900]!,
          Colors.brown[800]!,
        ],
      ),
    );
  }

  ButtonStyle _saveButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  SnackBar _buildSnackBar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}