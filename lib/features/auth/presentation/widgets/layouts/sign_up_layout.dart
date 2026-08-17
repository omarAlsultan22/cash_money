import 'package:cash_money/core/presentation/utils/helpers/validate/validator_input.dart';
import 'package:cash_money/features/auth/presentation/utils/validate/validate_email.dart';
import 'package:cash_money/features/auth/presentation/mixins/auth_mixin.dart';
import 'package:cash_money/core/presentation/widgets/icon_button_widget.dart';
import 'package:cash_money/core/presentation/widgets/build_input_field.dart';
import 'package:cash_money/features/auth/constants/auth_hints_texts.dart';
import 'package:cash_money/core/presentation/utils/form_validation.dart';
import 'package:cash_money/core/presentation/utils/ui_utils.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import '../../../../../core/data/models/message_result.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spaces.dart';
import '../../utils/validate/validate_password.dart';
import '../../../constants/auth_lables_texts.dart';
import 'package:flutter/material.dart';


class SignUpLayout extends StatefulWidget {
  final Future<void> Function({
  required String userName,
  required String userEmail,
  required String userPassword,
  }) onUpdate;
  final MessageResult messageResult;

  const SignUpLayout({
    super.key,
    required this.onUpdate,
    required this.messageResult
  });

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> with AuthMixin<SignUpLayout> {
  bool _isPressed = true;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  //controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const spaceBetweenFields = AppSpaces.vertical_16;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SignUpLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleMessageResult(
      messageResult: widget.messageResult,
      onNavigate: _navigateToBack,
    );
  }

  void _navigateToBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Scaffold(
      backgroundColor: AppColors.brown_900,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppPaddings.medium,
            child: RepaintBoundary(
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      AppSpaces.vertical_24,
                      _buildInputFields(),
                      AppSpaces.vertical_24,
                      _buildRegisterButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildNameField(),
        spaceBetweenFields,
        _buildEmailField(),
        spaceBetweenFields,
        _buildPasswordField(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.brown_900,
        scrolledUnderElevation: AppSizes.none,
        leading: const IconButtonWidget()
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an Account',
          style: Theme
              .of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(
            color: AppColors.amber_500,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpaces.vertical_8,
        Text(
          'Register now to join the world of happiness',
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return BuildInputField(
        prefixIcon: Icons.person,
        controller: _nameController,
        labelText: AppStrings.nameLabel,
        hintText: AppStrings.nameHint,
        autofillHints: const [AutofillHints.name],
        validator: (value) =>
            ValidateInput.validator(value!, AppStrings.nameLabel)
    );
  }

  Widget _buildEmailField() {
    return BuildInputField(
        prefixIcon: Icons.email,
        controller: _emailController,
        labelText: AuthLabelsTexts.emailLabelText,
        hintText: AuthHintsTexts.emailHintText,
        helperText: 'For example: example@gmail.com',
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        validator: (value) => ValidateEmail.validator(value!)
    );
  }

  Widget _buildPasswordField() {
    return BuildInputField(
        prefixIcon: Icons.lock,
        obscureText: _isObscure,
        controller: _passwordController,
        labelText: AuthLabelsTexts.passwordLabelText,
        hintText: AuthHintsTexts.passwordHintText,
        suffixIcon: buildPasswordVisibilityToggle(
            isObscure: _isObscure,
            onToggle: () =>
                setState(() {
                  _isObscure = !_isObscure;
                })
        ),
        autofillHints: const [AutofillHints.newPassword],
        validator: (value) => ValidatePassword.validator(value!)
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: UiUtils.buttonStyle(),
        onPressed: _isPressed
            ? () => _submitForm()
            : null,
        child: UiUtils.buildButtonContent(
          text: 'REGISTER',
            isLoading: widget.messageResult.isLoading
        ),
      ),
    );
  }

  void _updateLockButton(bool value) {
    setState(() => _isPressed = value);
  }

  Future<void> _submitForm() async {
    if (FormValidation.validator(_formKey)) {
      _updateLockButton(false);
      UiUtils.hideKeyboard(context);
      await _performRegistration();
    }
  }

  Future<void> _performRegistration() async {
    widget.onUpdate(
      userName: _nameController.text,
      userEmail: _emailController.text.trim(),
      userPassword: _passwordController.text,
    ).whenComplete(() => _updateLockButton(true));
  }
}