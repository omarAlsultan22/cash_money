import 'package:flutter/material.dart';
import '../../shared/cubit/state.dart';
import '../login_screen/login_screen.dart';
import 'change_email_&_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import 'package:cash_money/modules/sttings_screen/cubit.dart';
import 'package:cash_money/shared/components/constatnts.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _statesListener(AppDataStates state){
    if (state is AppDataSuccessState && state.key == Screens.update) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('تم التحديث بنجاح', Colors.green[800]!),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
    if (state is AppDataErrorState && state.key == Screens.update) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('فشل التحديث: ${state.error}', Colors.red[800]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppModelCubit>(
      create: (context) =>
      AppModelCubit()
        ..getInfo(UserDetails.uId),
      child: BlocConsumer<AppModelCubit, AppDataStates>(
        listener: (context, state) {
          _statesListener(state);
        },
        builder: (context, state) {
          return _widgetBuilder(context, state);
        },
      ),
    );
  }

  Widget _widgetBuilder(BuildContext context, AppDataStates state){
    final cubit = AppModelCubit.get(context);

    if (state is AppDataErrorState && state.key != Screens.update) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حدث خطأ: ${state.error}',
              style: TextStyle(color: Colors.red[400], fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => cubit.getInfo(UserDetails.uId),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state is AppDataSuccessState && state.key != Screens.update) {
      _nameController.text = state.userModel.name;
      _phoneController.text = state.userModel.phone;
      _locationController.text = state.userModel.location;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.brown[900],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'الإعدادات',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: _isLoading ? null : () => Navigator.pop(context),
            ),
          ),
          body: Container(
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
            child: _buildFormContent(context, cubit),
          ),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
      ),
    );
  }


  Widget _buildFormContent(BuildContext context, AppModelCubit cubit) {
    return IgnorePointer(
      ignoring: _isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 32),
              _buildInputField(
                controller: _nameController,
                label: "الاسم",
                hint: "أدخل اسمك",
                icon: Icons.person,
                validator: (value) => validateInput(value!, 'الاسم'),
              ),
              sizeBox(),
              _buildInputField(
                controller: _phoneController,
                label: "الهاتف",
                hint: "أدخل رقم هاتفك",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => validateInput(value!, 'الهاتف'),
              ),
              sizeBox(),
              _buildInputField(
                controller: _locationController,
                label: "العنوان",
                hint: "أدخل عنوانك",
                icon: Icons.location_on,
                validator: (value) => validateInput(value!, 'العنوان'),
              ),
              const SizedBox(height: 24),
              _buildChangePasswordButton(),
              const SizedBox(height: 16),
              _buildUpdateButton(cubit),
              if (_isLoading) ...[
                const SizedBox(height: 24),
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديث الملف الشخصي',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.amber[400],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'قم بتحديث معلوماتك الشخصية',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    TextInputType? keyboardType,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(dynamic value) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        buildInputField(
            fillColor: true,
            controller: controller,
            hint: hint,
            icon: icon,
            validator: validator
        )
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.amber[700]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangeEmailAndPassword(),
            ),
          );
        },
        child: Text(
          'تغيير البريد وكلمة المرور',
          style: TextStyle(
            fontSize: 18,
            color: Colors.amber[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(AppModelCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() => _isLoading = true);
            cubit.updateInfo(
              name: _nameController.text,
              phone: _phoneController.text,
              location: _locationController.text,
              uId: UserDetails.uId,
            ).whenComplete(() {
              if (mounted) setState(() => _isLoading = false);
            });
          }
        },
        child: const Text(
          'تحديث',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
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
}