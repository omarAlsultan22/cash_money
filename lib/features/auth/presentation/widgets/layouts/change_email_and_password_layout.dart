import 'package:cash_money/features/auth/presentation/cubits/auth_operations.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/sized_box.dart';
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
        backgroundColor: Colors.brown[900],
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
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

  Future<void> _onSavePressed() async {
    if (!_validateForm()) return;
    await _saveChanges();
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (newPasswordController.text != repeatNewPasswordController.text) {
      buildSnackBar('كلمة المرور الجديدة غير متطابقة', Colors.red[800]!);
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
    CacheHelper.removeData(key: 'uId');
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
          buildSnackBar('تم التحديث بنجاح', Colors.green[800]!)
      );
      navigator(context: context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar('فشل التحديث: ${message.error}', Colors.red[800]!),
      );
    }
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
}