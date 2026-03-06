import 'package:cash_money/features/auth/presentation/widgets/auth_sized_boxes.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/utils/validate_input.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/app_sized_boxes.dart';
import 'package:cash_money/core/constants/numbers_constants.dart';
import '../../../../../core/constants/texts_constants.dart';
import '../../../constants/auth_texts_constants.dart';
import '../../operations/auth_operations.dart';
import 'package:flutter/material.dart';


class RegisterLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const RegisterLayout(this._authOperations, {super.key});

  @override
  State<RegisterLayout> createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends State<RegisterLayout> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  static const height_16 = AppSizedBoxes.height_16;
  static const height24 = AppSizedBoxes.height_24;

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: _buildAppBar(),
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
                    height24,
                    _buildInputFields(),
                    height24,
                    _buildRegisterButton(),
                  ],
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
        height_16,
        _buildEmailField(),
        height_16,
        _buildPasswordField(),
        height_16,
        _buildPhoneField(),
        height_16,
        _buildLocationField(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.brown.shade900,
      scrolledUnderElevation: NumbersConstants.zero,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => _navigateBack,
      ),
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
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Register now to join the world of happiness',
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

  Widget _buildNameField() {
    return buildInputField(
      controller: _nameController,
      labelText: "Full Name",
      hintText: "Enter your full name",
      prefixIcon: Icons.person,
      autofillHints: const [AutofillHints.name],
      validator: (value) => validateInput(value!, 'name'),
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
      validator: (value) => validateInput(value!, 'email'),
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
      autofillHints: const [AutofillHints.newPassword],
      validator: (value) => validateInput(value!, 'password'),
    );
  }

  Widget _buildPhoneField() {
    return buildInputField(
      controller: _phoneController,
      labelText: "Phone Number",
      hintText: "Enter your phone number",
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      validator: (value) => validateInput(value!, 'phone'),
    );
  }

  Widget _buildLocationField() {
    return buildInputField(
      controller: _locationController,
      labelText: "Location",
      hintText: "Enter your location",
      prefixIcon: Icons.location_on,
      validator: (value) => validateInput(value!, 'location'),
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

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _registerButtonStyle(),
        onPressed: _isLoading ? null : _submitForm,
        child: _buildRegisterButtonContent(),
      ),
    );
  }

  Widget _buildRegisterButtonContent() {
    return _isLoading
        ? AuthSizedBoxes.sizedBox
        : const Text(
      "REGISTER",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }


  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      await _performRegistration();
    }
  }

  Future<void> _performRegistration() async {
    setState(() => _isLoading = true);
    final message = await widget._authOperations.signUp(
      userName: _nameController.text.trim(),
      userEmail: _emailController.text.trim(),
      userPassword: _passwordController.text,
      userPhone: _phoneController.text.trim(),
      userLocation: _locationController.text.trim(),
    );
    setState(() => _isLoading = false);
    _showMessageResult(message);
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
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
          buildSnackBar(' ${TextsConstants.failed}${message.error}', const Color(0xFFC62828))
      );
    }
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  ButtonStyle _registerButtonStyle() {
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