import 'package:cash_money/features/auth/presentation/widgets/auth_sized_boxes.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/app_sized_boxes.dart';
import '../../../../../core/data/models/message_result_model.dart';
import 'package:cash_money/core/constants/numbers_constants.dart';
import 'package:cash_money/core/constants/texts_constants.dart';
import '../../../constants/auth_texts_constants.dart';
import '../../../../home/screens/home_screen.dart';
import '../../operations/auth_operations.dart';
import '../../screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const LoginLayout(this._authOperations, {super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const height_16 = AppSizedBoxes.height_16;
  static const height_24 = AppSizedBoxes.height_24;

  bool _isObscure = true;
  bool _isLoading = false;

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
  Widget build(BuildContext context) {
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildEmailField(),
                    height_16,
                    _buildPasswordField(),
                    height_24,
                    _buildLoginButton(),
                    height_16,
                    _buildRegisterLink(),
                  ],
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
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSizedBoxes.height_8,
        Text(
          'Login now to communicate with friends',
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: const Color(0xFFBDBDBD),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return buildInputField(
      controller: _emailController,
      labelText: AuthTextsConstants.emailLabelText,
      hintText: AuthTextsConstants.emailHintText,
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: (value) => _validateEmail(value),
    );
  }

  Widget _buildPasswordField() {
    return buildInputField(
      controller: _passwordController,
      labelText: AuthTextsConstants.passwordLabelText,
      hintText: AuthTextsConstants.passwordHintText,
      prefixIcon: Icons.lock,
      obscureText: _isObscure,
      suffixIcon: _buildPasswordVisibilityToggle(),
      autofillHints: const [AutofillHints.password],
      validator: (value) => _validatePassword(value),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.amber,
      ),
      onPressed: _togglePasswordVisibility,
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _loginButtonStyle(),
        onPressed: _isLoading ? null : () => _submitForm(),
        child: _buildLoginButtonContent(),
      ),
    );
  }

  Widget _buildLoginButtonContent() {
    return _isLoading
        ? AuthSizedBoxes.sizedBox
        : const Text(
      "LOGIN",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: _navigateToRegister,
        child: RichText(
          text: const TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: "Register Now",
                style: TextStyle(
                  color: Colors.amber,
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
    final value = await CacheHelper.getValue(key: TextsConstants.uId);
    if (value?.isNotEmpty ?? false) {
      _navigateToHome();
    }
  }


  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      setState(() => _isLoading = true);
      final message = await widget._authOperations.signIn(
        userEmail: _emailController.text.trim(),
        userPassword: _passwordController.text,
      );
      setState(() => _isLoading = false);
      _showMessageResult(message);
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(TextsConstants.success, const Color(0xFF2E7D32))
      );
      navigator(context: context, link: const HomeScreen());
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(' ${TextsConstants.failed}${message.error}', const Color(0xFFC62828)),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال عنوان بريدك الإلكتروني";
    }
    if (!value.contains('@')) {
      return 'يرجى إدخال عنوان بريد إلكتروني صالح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال كلمة المرور الخاصة بك";
    }
    if (value.length < 6) {
      return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
    }
    return null;
  }

  ButtonStyle _loginButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NumbersConstants.fifty),
      ),
      elevation: 2,
    );
  }
}