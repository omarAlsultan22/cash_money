import '../../../../../core/presentation/utils/helpers/validate/validator_input.dart';
import '../../../../auth/presentation/screens/change_email_&_password_screen.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import 'package:cash_money/core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import 'package:cash_money/core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/app_spacing.dart';
import 'package:cash_money/core/constants/app_labels_texts.dart';
import 'package:cash_money/core/constants/app_hints_texts.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import 'package:cash_money/core/constants/app_numbers.dart';
import 'package:cash_money/core/constants/app_states.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../cubits/settings_cubit.dart';
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
  late SettingsCubit _cubit;

  //colors
  static const _white = AppColors.white;
  static const _amber = AppColors.amber_600;
  static const _brown = AppColors.brown_900;

  //paddings
  static const _paddingVertical = AppPaddings.paddingVertical;

  //borderRadius
  static const borderRadius = BorderRadius.all(Radius.circular(12.0));

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SettingsCubit>();
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
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _brown,
        appBar: _buildAppBar(),
        body: _buildBody(context, _cubit),
      ),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: AppNumbers.zero,
      title: const Text(
        'Settings',
        style: TextStyle(color: _white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: _white,
        onPressed: _isLoading ? null : () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SettingsCubit cubit) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: _buildFormContent(context, cubit),
    );
  }

  Widget _buildFormContent(BuildContext context, SettingsCubit cubit) {
    const spaceBetweenFields = AppSpacing.height_16;

    return IgnorePointer(
      ignoring: _isLoading,
      child: SingleChildScrollView(
        padding: AppPaddings.paddingAll_24,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              AppSpacing.height_32,
              _buildNameField(),
              spaceBetweenFields,
              _buildPhoneField(),
              spaceBetweenFields,
              _buildLocationField(),
              AppSpacing.height_24,
              _buildChangePasswordButton(),
              AppSpacing.height_16,
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
          'Update profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.amber_400,
          ),
        ),
        AppSpacing.height_8,
        Text(
          'Update your personal information',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    const name = AppLabelsTexts.name;

    return _buildCustomInputField(
      controller: _nameController,
      label: name,
      hint: AppHintsTexts.name,
      icon: Icons.person,
      validator: (value) => ValidateInput.validator(value, name),
    );
  }

  Widget _buildPhoneField() {
    const phoneNumber = AppLabelsTexts.phoneNumber;

    return _buildCustomInputField(
      controller: _phoneController,
      label: phoneNumber,
      hint: AppHintsTexts.phoneNumber,
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) => ValidateInput.validator(value, phoneNumber),
    );
  }

  Widget _buildLocationField() {
    const location = AppLabelsTexts.location;

    return _buildCustomInputField(
      controller: _locationController,
      label: location,
      hint: AppHintsTexts.location,
      icon: Icons.location_on,
      validator: (value) => ValidateInput.validator(value, location),
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
        AppSpacing.height_8,
        BuildInputField.build(
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
          'Change email and password',
          style: TextStyle(
            fontSize: 18,
            color: _amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(SettingsCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _updateButtonStyle(),
        onPressed: () => _onUpdatePressed(cubit),
        child: const Text(
          'Update',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        AppSpacing.height_24,
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.amber_500),
          ),
        ),
      ],
    );
  }

  Future<void> _onUpdatePressed(SettingsCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      final uId = await CacheHelper.getValue(key: AppKeys.uId) ?? '';
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
          BuildSnackBar.build(AppStates.success, AppColors.green800)
      );
      navigator(context: context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          BuildSnackBar.build(
              ' ${AppStates.failed}${message.error}', AppColors.red800)
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

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _brown,
          AppColors.brown_800,
        ],
      ),
    );
  }

  ButtonStyle _changePasswordButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: _paddingVertical,
      side: const BorderSide(color: _amber),
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _amber,
      padding: _paddingVertical,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      elevation: 4,
    );
  }
}