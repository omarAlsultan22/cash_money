import '../../../../auth/presentation/screens/change_email_&_password_screen.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import 'package:cash_money/core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/app_sized_boxes.dart';
import 'package:cash_money/core/constants/numbers_constants.dart';
import 'package:cash_money/core/constants/texts_constants.dart';
import '../../cubits/update_user_Info_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class SettingsLayout extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String userLocation;

  const SettingsLayout({
    required this.userName,
    required this.userPhone,
    required this.userLocation,
    Key? key}) : super(key: key);

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;
  late UpdateUserInfoCubit cubit;

  static const twelve = NumbersConstants.twelve;
  static const height_16 = AppSizedBoxes.height_16;

  @override
  void initState() {
    super.initState();
    cubit = context.read<UpdateUserInfoCubit>();
    _initializeControllers(
        userName: widget.userName,
        userPhone: widget.userPhone,
        userLocation: widget.userLocation
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initializeControllers({
    required String? userName,
    required String? userPhone,
    required String? userLocation,
  }) {
    _nameController.text = userName ?? '';
    _phoneController.text = userPhone ?? '';
    _locationController.text = userLocation ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF3E2723),
        appBar: _buildAppBar(),
        body: _buildBody(context, cubit),
      ),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: NumbersConstants.zero,
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

  Widget _buildBody(BuildContext context, UpdateUserInfoCubit cubit) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: _buildFormContent(context, cubit),
    );
  }

  Widget _buildFormContent(BuildContext context, UpdateUserInfoCubit cubit) {
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
              height_16,
              _buildPhoneField(),
              height_16,
              _buildLocationField(),
              AppSizedBoxes.height_24,
              _buildChangePasswordButton(),
              AppSizedBoxes.height_16,
              _buildUpdateButton(cubit),
              if (_isLoading) _buildLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديث الملف الشخصي',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFCA28),
          ),
        ),
        AppSizedBoxes.height_8,
        Text(
          'قم بتحديث معلوماتك الشخصية',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFBDBDBD),
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
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 16,
          ),
        ),
        AppSizedBoxes.height_8,
        buildInputField(
          controller: controller,
          hintText: hint,
          prefixIcon: icon,
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
        child: const Text(
          'تغيير البريد وكلمة المرور',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFFFB300),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(UpdateUserInfoCubit cubit) {
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

  Future<void> _onUpdatePressed(UpdateUserInfoCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      final uId = await CacheHelper.getValue(key: TextsConstants.uId) ?? '';
      setState(() => _isLoading = true);
      final message = await cubit.updateInfo(
        userName: _nameController.text,
        userPhone: _phoneController.text,
        userLocation: _locationController.text,
        uId: uId,
      );
      setState(() => _isLoading = false);
      _showMessageResult(message);
    }
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

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangeEmailAndPasswordScreen(),
      ),
    );
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3E2723),
          Color(0xFF4E342E),
        ],
      ),
    );
  }

  ButtonStyle _changePasswordButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: const BorderSide(color: Color(0xFFFFB300)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(twelve),
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFB300),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(twelve),
      ),
      elevation: 4,
    );
  }
}