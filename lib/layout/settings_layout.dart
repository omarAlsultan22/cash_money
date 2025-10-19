import '../modules/sttings_screen/change_email_&_password_screen.dart';
import 'package:cash_money/modules/sttings_screen/cubit.dart';
import 'package:cash_money/shared/components/constatnts.dart';
import '../modules/login_screen/login_screen.dart';
import '../../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/state.dart';
import 'package:flutter/material.dart';


class SettingsLayout extends StatefulWidget {
  const SettingsLayout({Key? key}) : super(key: key);

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppModelCubit, AppDataStates>(
      listener: _statesListener,
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  Widget _buildMainContent(BuildContext context, AppDataStates state) {
    final cubit = AppModelCubit.get(context);

    if (state is AppDataErrorState && state.key != Screens.update) {
      return _buildErrorState(cubit, state);
    }

    if (state is AppDataSuccessState && state.key != Screens.update) {
      _initializeControllers(state);
      return _buildSuccessState(context, cubit);
    }

    return _buildLoadingState();
  }

  Widget _buildErrorState(AppModelCubit cubit, AppDataErrorState state) {
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

  Widget _buildSuccessState(BuildContext context, AppModelCubit cubit) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.brown[900],
        appBar: _buildAppBar(),
        body: _buildBody(context, cubit),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody(BuildContext context, AppModelCubit cubit) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: _buildFormContent(context, cubit),
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
              _buildNameField(),
              sizeBox(),
              _buildPhoneField(),
              sizeBox(),
              _buildLocationField(),
              const SizedBox(height: 24),
              _buildChangePasswordButton(),
              const SizedBox(height: 16),
              _buildUpdateButton(cubit),
              if (_isLoading) _buildLoadingIndicator(),
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

  Widget _buildNameField() {
    return _buildCustomInputField(
      controller: _nameController,
      label: "الاسم",
      hint: "أدخل اسمك",
      icon: Icons.person,
      validator: (value) => _validateInput(value, 'الاسم'),
    );
  }

  Widget _buildPhoneField() {
    return _buildCustomInputField(
      controller: _phoneController,
      label: "الهاتف",
      hint: "أدخل رقم هاتفك",
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) => _validateInput(value, 'الهاتف'),
    );
  }

  Widget _buildLocationField() {
    return _buildCustomInputField(
      controller: _locationController,
      label: "العنوان",
      hint: "أدخل عنوانك",
      icon: Icons.location_on,
      validator: (value) => _validateInput(value, 'العنوان'),
    );
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    required String? Function(dynamic) validator,
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
          controller: controller,
          hint: hint,
          icon: icon,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: _changePasswordButtonStyle(),
        onPressed: _navigateToChangePassword,
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
        style: _updateButtonStyle(),
        onPressed: () => _onUpdatePressed(cubit),
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

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        SizedBox(height: 24),
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),
      ],
    );
  }

  void _statesListener(BuildContext context, AppDataStates state) {
    if (state is AppDataSuccessState && state.key == Screens.update) {
      _showSuccessMessage();
    }
    if (state is AppDataErrorState && state.key == Screens.update) {
      _showErrorMessage(state.error!);
    }
  }

  void _initializeControllers(AppDataSuccessState state) {
    _nameController.text = state.userModel.name;
    _phoneController.text = state.userModel.phone;
    _locationController.text = state.userModel.location;
  }

  void _onUpdatePressed(AppModelCubit cubit) {
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
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangeEmailAndPasswordScreen(),
      ),
    );
  }

  void _showSuccessMessage() {
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

  void _showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('فشل التحديث: $error', Colors.red[800]!),
    );
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.brown[900]!,
          Colors.brown[800]!,
        ],
      ),
    );
  }

  ButtonStyle _changePasswordButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: BorderSide(color: Colors.amber[700]!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber[700],
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
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