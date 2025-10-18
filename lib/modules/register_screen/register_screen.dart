import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح عند الإرسال
      await context.read<RegisterCubit>().userRegister(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
      );
    }
  }

  void _statesListener(AppDataStates state) {
    if (state is AppDataErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
    if (state is AppDataSuccessState) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, AppDataStates>(
        listener: (context, state) {
          _statesListener(state);
        },
        builder: (context, state) {
          return buildWidget(state);
        },
      ),
    );
  }

  Widget buildWidget(AppDataStates state) {
    _isLoading = state is AppDataLoadingState;

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

                    // حقول الإدخال
                    _buildNameField(),
                    sizeBox(),

                    _buildEmailField(),
                    sizeBox(),

                    _buildPasswordField(),
                    sizeBox(),

                    _buildPhoneField(),
                    sizeBox(),

                    _buildLocationField(),
                    const SizedBox(height: 24),

                    // زر التسجيل
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.brown.shade900,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
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
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.amber,
        ),
        onPressed: _togglePasswordVisibility,
      ),
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

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 2,
        ),
        onPressed: _isLoading ? null : _submitForm,
        child: _isLoading
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
        ),
      ),
    );
  }
}