import 'package:cash_money/features/auth/presentation/widgets/auth_sized_boxes.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/app_sized_boxes.dart';
import '../../../../../core/data/models/message_result_model.dart';
import 'package:cash_money/core/constants/texts_constants.dart';
import '../../../../../core/constants/numbers_constants.dart';
import '../../operations/auth_operations.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const ChangeEmailAndPasswordLayout(this._authOperations, {super.key});

  @override
  State<ChangeEmailAndPasswordLayout> createState() => _ChangeEmailAndPasswordLayoutState();
}

class _ChangeEmailAndPasswordLayoutState extends State<ChangeEmailAndPasswordLayout> {
  final formKey = GlobalKey<FormState>();
  final newEmailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatNewPasswordController = TextEditingController();

  static const height_16 = AppSizedBoxes.height_16;

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
    return _buildMainContent(context);
  }

  Widget _buildMainContent(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF3E2723),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: NumbersConstants.zero,
      leading: _buildBackButton(),
      title: const Text(
        'تغيير البريد وكلمة المرور',
        style: TextStyle(color: Colors.white),
      ),
      actions: [_buildSaveButton()],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: _isLoading ? null : () => Navigator.pop(context),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: _saveButtonStyle(),
        onPressed: _isLoading ? null : () => _onSavePressed(),
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
                  height_16,
                  _buildCurrentPasswordField(),
                  height_16,
                  _buildNewPasswordField(),
                  height_16,
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
      hintText: 'يمكنك اضافة بريد إلكتروني الجديد',
      prefixIcon: Icons.email,
      validator: (value) => _validateInput(value, 'البريد الإلكتروني'),
    );
  }

  Widget _buildCurrentPasswordField() {
    const currentPassword = 'كلمة المرور الحالية';
    return buildInputField(
      controller: currentPasswordController,
      hintText: currentPassword,
      prefixIcon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value, currentPassword),
    );
  }

  Widget _buildNewPasswordField() {
    const newPassword = 'كلمة المرور الجديدة';
    return buildInputField(
      controller: newPasswordController,
      hintText: newPassword,
      prefixIcon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value, newPassword),
    );
  }

  Widget _buildConfirmPasswordField() {
    return buildInputField(
      controller: repeatNewPasswordController,
      hintText: "تأكيد كلمة المرور الجديدة",
      prefixIcon: Icons.lock_reset,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: _validatePasswordConfirmation,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        AppSizedBoxes.height_24,
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
        color: const Color(0xFFFFB300),
      ),
      onPressed: () => setState(() => isObscure = !isObscure),
    );
  }

  Future<void> _onSavePressed() async {
    if (!_validateForm()) return;
    await _saveChanges();
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (newPasswordController.text != repeatNewPasswordController.text) {
      buildSnackBar('كلمة المرور الجديدة غير متطابقة', const Color(0xFFC62828));
      return false;
    }

    return true;
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    final message = await widget._authOperations.changeEmailAndPassword(
        newEmail: newEmailController.text,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text
    );

    _clearUserData();
    setState(() => _isLoading = false);
    _showMessageResult(message);
  }


  void _clearUserData() {
    CacheHelper.removeData(key: TextsConstants.uId);
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

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(TextsConstants.success, const Color(0xFF2E7D32))
      );
      navigator(context: context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(' ${TextsConstants.failed}${message.error}', const Color(0xFFC62828)),
      );
    }
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3E2723),
          Color(0xFF4E342E),
        ],
      ),
    );
  }

  ButtonStyle _saveButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFB300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}