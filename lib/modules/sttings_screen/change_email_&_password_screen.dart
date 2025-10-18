import 'package:cash_money/shared/components/components.dart';
import 'package:cash_money/shared/local/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class ChangeEmailAndPassword extends StatefulWidget {
  const ChangeEmailAndPassword({super.key});

  @override
  State<ChangeEmailAndPassword> createState() => _ChangeEmailAndPasswordState();
}

class _ChangeEmailAndPasswordState extends State<ChangeEmailAndPassword> {
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

  IconButton _buildVisibilityToggle() =>
      IconButton(
        icon: Icon(
          isObscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.amber[700],
        ),
        onPressed: () => setState(() => isObscure = !isObscure),
      );

  Future<void> _saveChanges({
    required BuildContext context,
    required AppModelCubit cubit,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != repeatNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('كلمة المرور الجديدة غير متطابقة', Colors.red[800]!),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await cubit.changeEmailAndPassword(
        newEmail: newEmailController.text,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      ).then((_) {
        CacheHelper.removeData(key: 'uId');
      }).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('فشل التحديث: $error', Colors.red[800]!),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  SnackBar _buildSnackBar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppModelCubit>(create: (context) => AppModelCubit(),
      child: BlocBuilder<AppModelCubit, AppDataStates>(
          builder: (context, state) {
            return _widgetBuilder(context);
          }),
    );
  }

  Widget _widgetBuilder(BuildContext context) {
    var cubit = AppModelCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.brown[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: _isLoading ? null : () => Navigator.pop(context),
          ),
          title: const Text(
            'تغيير البريد وكلمة المرور',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSaveButton(cubit),
            ),
          ],
        ),
        body: _buildFormContent(),
      ),
    );
  }


  Widget _buildSaveButton(AppModelCubit cubit) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: _isLoading ? null : () =>
          _saveChanges(context: context, cubit: cubit),
      child: _isLoading
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
      ),
    );
  }

  Widget _buildFormContent() {
    return IgnorePointer(
      ignoring: _isLoading,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown[900]!,
              Colors.brown[800]!,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  buildInputField(
                    controller: newEmailController,
                    hint: "البريد الإلكتروني الجديد",
                    icon: Icons.email,
                    validator: (value) =>
                        validateInput(value, 'البريد الإلكتروني'),
                  ),
                  sizeBox(),
                  buildInputField(
                    controller: currentPasswordController,
                    hint: "كلمة المرور الحالية",
                    icon: Icons.lock,
                    obscureText: isObscure,
                    suffixIcon: _buildVisibilityToggle(),
                    validator: (value) =>
                        validateInput(value, 'كلمة المرور الحالية'),
                  ),
                  sizeBox(),
                  buildInputField(
                    controller: newPasswordController,
                    hint: "كلمة المرور الجديدة",
                    icon: Icons.lock,
                    obscureText: isObscure,
                    suffixIcon: _buildVisibilityToggle(),
                    validator: (value) =>
                        validateInput(value, 'كلمة المرور الجديدة'),
                  ),
                  sizeBox(),
                  buildInputField(
                    controller: repeatNewPasswordController,
                    hint: "تأكيد كلمة المرور الجديدة",
                    icon: Icons.lock_reset,
                    obscureText: isObscure,
                    suffixIcon: _buildVisibilityToggle(),
                    validator: (value) {
                      if (value!.isEmpty) return 'يرجى تأكيد كلمة المرور';
                      if (value != newPasswordController.text) {
                        return 'كلمات المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),
                  if (_isLoading) ...[
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}