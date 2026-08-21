import 'package:cash_money/features/auth/presentation/utils/validate/validate_email.dart';
import 'package:cash_money/features/auth/presentation/mixins/auth_mixin.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/core/presentation/widgets/build_input_field.dart';
import 'package:cash_money/features/auth/constants/auth_hints_texts.dart';
import '../../../../../core/presentation/utils/form_validation.dart';
import 'package:cash_money/core/presentation/utils/ui_utils.dart';
import '../../../../../core/data/models/message_result.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../../../../core/constants/app_spaces.dart';
import '../../utils/validate/validate_password.dart';
import '../../../constants/auth_lables_texts.dart';
import '../../../../home/screens/home_screen.dart';
import '../../screens/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignInLayout extends StatefulWidget {
  final Future<void> Function({
  required String userEmail,
  required String userPassword
  }) signIn;
  final CacheHelper cacheHelper;
  final MessageResult messageResult;
  const SignInLayout({
    super.key,
    required this.signIn,
    required this.cacheHelper,
    required this.messageResult
  });

  @override
  State<SignInLayout> createState() => _SignInLayoutState();
}

class _SignInLayoutState extends State<SignInLayout> with AuthMixin<SignInLayout> {
  bool _isPressed = true;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SignInLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleMessageResultAndNavigate(
        messageResult: widget.messageResult,
        onNavigate: () =>
            _navigateToHome()
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Scaffold(
      backgroundColor: AppColors.brown_900,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppPaddings.large,
            child: RepaintBoundary(
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      AppSpaces.vertical_32,
                      _buildEmailField(),
                      AppSpaces.vertical_16,
                      _buildPasswordField(),
                      AppSpaces.vertical_24,
                      _buildLoginButton(),
                      AppSpaces.vertical_16,
                      _buildRegisterLink(),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOGIN',
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
          'Login now to communicate with friends',
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

  Widget _buildEmailField() {
    return BuildInputField(
      controller: _emailController,
      labelText: AuthLabelsTexts.emailLabelText,
      hintText: AuthHintsTexts.emailHintText,
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: (value) => ValidateEmail.validator(value),
    );
  }

  Widget _buildPasswordField() {
    return BuildInputField(
      controller: _passwordController,
      labelText: AuthLabelsTexts.passwordLabelText,
      hintText: AuthHintsTexts.passwordHintText,
      prefixIcon: Icons.lock,
      obscureText: _isObscure,
      suffixIcon: buildPasswordVisibilityToggle(
          isObscure: _isObscure,
          onToggle: () =>
              setState(() {
                _isObscure = !_isObscure;
              })
      ),
      autofillHints: const [AutofillHints.password],
      validator: (value) => ValidatePassword.validator(value),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: UiUtils.buttonStyle(),
        onPressed: _isPressed
            ? () => _submitForm()
            : null,
        child: UiUtils.buildButtonContent(
            text: 'LOGIN',
            isLoading: widget.messageResult.isLoading),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: _navigateToRegister,
        child: RichText(
          text: const TextSpan(
            text: 'Don\'t have an account? ',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: AppSizes.fontSize_16,
            ),
            children: [
              TextSpan(
                text: "Register Now",
                style: TextStyle(
                  color: AppColors.amber_500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    final value = await widget.cacheHelper.getString(key: AppKeys.uId);
    if (value != null) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    navigateToScreen(const HomeScreen());
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _updateLockButton(bool value) {
    setState(() => _isPressed = value);
  }

  Future<void> _submitForm() async {
    if (FormValidation.validator(_formKey)) {
      _updateLockButton(false);
      UiUtils.hideKeyboard(context);
      widget.signIn(
          userEmail: _emailController.text.trim(),
          userPassword: _passwordController.text
      ).whenComplete(() => _updateLockButton(true));
    }
  }
}