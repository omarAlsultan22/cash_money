import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/sized_box.dart';
import '../../../../home/screens/home_screen.dart';
import '../../screens/register_screen.dart';
import '../../cubits/auth_operations.dart';
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
      backgroundColor: Colors.brown.shade900,
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
                    sizeBox(),
                    _buildPasswordField(),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    sizeBox(),
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
        const SizedBox(height: 8),
        Text(
          'Login now to communicate with friends',
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return buildInputField(
      controller: _emailController,
      label: "Email Address",
      hint: "Enter your email",
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: (value) => _validateEmail(value),
    );
  }

  Widget _buildPasswordField() {
    return buildInputField(
      controller: _passwordController,
      label: "Password",
      hint: "Enter your password",
      icon: Icons.lock,
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
        ? const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 3,
      ),
    )
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
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            children: const [
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
    final value = await CacheHelper.getValue(key: 'uId');
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
          buildSnackBar('تم التحديث بنجاح', Colors.green[800]!)
      );
      navigator(context: context, link: const HomeScreen());
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar('فشل التحديث: ${message.error}', Colors.red[800]!),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  ButtonStyle _loginButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 2,
    );
  }
}