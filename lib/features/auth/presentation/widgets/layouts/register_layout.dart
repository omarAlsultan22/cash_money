import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/utils/validate_input.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/sized_box.dart';
import '../../cubits/auth_operations.dart';
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
      backgroundColor: Colors.brown.shade900,
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
                    const SizedBox(height: 24),
                    _buildInputFields(),
                    const SizedBox(height: 24),
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
        sizeBox(),
        _buildEmailField(),
        sizeBox(),
        _buildPasswordField(),
        sizeBox(),
        _buildPhoneField(),
        sizeBox(),
        _buildLocationField(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.brown.shade900,
      scrolledUnderElevation: 0,
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
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return buildInputField(
      controller: _nameController,
      label: "Full Name",
      hint: "Enter your full name",
      icon: Icons.person,
      autofillHints: const [AutofillHints.name],
      validator: (value) => validateInput(value!, 'name'),
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
      validator: (value) => validateInput(value!, 'email'),
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
      autofillHints: const [AutofillHints.newPassword],
      validator: (value) => validateInput(value!, 'password'),
    );
  }

  Widget _buildPhoneField() {
    return buildInputField(
      controller: _phoneController,
      label: "Phone Number",
      hint: "Enter your phone number",
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      validator: (value) => validateInput(value!, 'phone'),
    );
  }

  Widget _buildLocationField() {
    return buildInputField(
      controller: _locationController,
      label: "Location",
      hint: "Enter your location",
      icon: Icons.location_on,
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
        ? const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 3,
      ),
    )
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
          buildSnackBar('تم التحديث بنجاح', Colors.green[800]!)
      );
      navigator(context: context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar('فشل التحديث: ${message.error}', Colors.red[800]!)
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
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 2,
    );
  }
}