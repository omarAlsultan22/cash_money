import 'package:cash_money/shared/local/shared_preferences.dart';
import '../modules/register_screen/register_screen.dart';
import '../../shared/components/components.dart';
import '../modules/home_screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/login_screen/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/state.dart';


class LoginLayout extends StatefulWidget {
  const LoginLayout({Key? key}) : super(key: key);

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
    _initializeForm();
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
    return BlocConsumer<LoginCubit, AppDataStates>(
      listener: _statesListener,
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  Widget _buildMainContent(BuildContext context, AppDataStates state) {
    final cubit = BlocProvider.of<LoginCubit>(context);
    _updateLoadingState(state);

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
                    _buildLoginButton(cubit),
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
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Login now to communicate with friends',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildLoginButton(LoginCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _loginButtonStyle(),
        onPressed: _isLoading ? null : () => _submitForm(cubit),
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

  void _statesListener(BuildContext context, AppDataStates state) {
    if (state is AppDataSuccessState) {
      _navigateToHome();
    } else if (state is AppDataErrorState) {
      _showErrorSnackBar(state.error!);
    }
  }

  void _initializeForm() {
    // إزالة القيم الثابتة في production - هذه للاختبار فقط
    _emailController.text = 'omaralsultan22@gmail.com';
    _passwordController.text = '254086aaa';
  }

  Future<void> _checkLoginStatus() async {
    final value = await CacheHelper.getValue(key: 'uId');
    if (value?.isNotEmpty ?? false) {
      _navigateToHome();
    }
  }

  void _updateLoadingState(AppDataStates state) {
    setState(() {
      _isLoading = state is AppDataLoadingState;
    });
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

  Future<void> _submitForm(LoginCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      cubit.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
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