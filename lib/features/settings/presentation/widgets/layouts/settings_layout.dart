import '../../../../../core/presentation/utils/helpers/validate/validator_input.dart';
import '../../../../auth/presentation/screens/change_email_and_password_screen.dart';
import 'package:cash_money/core/presentation/widgets/icon_button_widget.dart';
import 'package:cash_money/core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/loading_widget.dart';
import 'package:cash_money/core/constants/app_labels_texts.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import 'package:cash_money/core/constants/app_hints_texts.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spaces.dart';
import 'package:flutter/material.dart';


class SettingsLayout extends StatefulWidget {
  final UserModel userModel;
  final MessageResult messageResult;
  final void Function(UserModel) onUpdate;

  const SettingsLayout({
    required this.onUpdate,
    required this.userModel,
    required this.messageResult,
    Key? key}) : super(key: key);

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();


  //sizes
  static const _elevation = 4.0;
  static const _fontSize18 = 18.0;
  static const _fontSize28 = 28.0;

  //colors
  static const _amber = AppColors.amber_600;
  static const _brown = AppColors.brown_900;

  //paddings
  static const _paddingVertical = AppPaddings.symmetricVertical;

  //spacing
  static const _spaceBetweenFields = AppSpaces.height_16;

  //borderRadius
  static const _radiusValue = 12.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(_radiusValue));

  @override
  void initState() {
    super.initState();
    _initializeControllers(
        userName: widget.userModel.userName,
        userPhone: widget.userModel.userPhone,
        userLocation: widget.userModel.userLocation
    );
  }

  @override
  void didUpdateWidget(covariant SettingsLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
    }
    setState((){});
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
        body: _buildBody(),
      ),
    );
  }

  void _showMessageResult(MessageResult messageResult) {
    ScaffoldMessenger.of(context).showSnackBar(
        BuildSnackBar.build(messageResult.message!, messageResult.color!)
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.transparent,
        elevation: AppSizes.none,
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.white),
        ),
        leading: const IconButtonWidget()
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: _buildFormContent(),
    );
  }

  Widget _buildFormContent() {
    return IgnorePointer(
      ignoring: widget.messageResult.isLoading,
      child: SingleChildScrollView(
        padding: AppPaddings.large,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              AppSpaces.height_32,
              _buildNameField(),
              _spaceBetweenFields,
              _buildPhoneField(),
              _spaceBetweenFields,
              _buildLocationField(),
              AppSpaces.height_24,
              _buildChangePasswordButton(),
              AppSpaces.height_16,
              _buildUpdateButton(),
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
            fontSize: _fontSize28,
            fontWeight: FontWeight.bold,
            color: AppColors.amber_400,
          ),
        ),
        AppSpaces.height_8,
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
            fontSize: AppSizes.fontSize_16,
          ),
        ),
        AppSpaces.height_8,
        BuildInputField(
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
            fontSize: _fontSize18,
            color: _amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: _updateButtonStyle(),
          onPressed: () {
            widget.onUpdate(
                UserModel(
                    userName: _nameController.text,
                    userPhone: _phoneController.text,
                    userLocation: _locationController.text,
                    isEmailVerified: true
                )
            );
            setState(() {});
          },
          child: _buildUpdateButtonContent()
      ),
    );
  }

  Widget _buildUpdateButtonContent() {
    return widget.messageResult.isLoading
        ? LoadingWidget.sizedBox
        : const Text(
      "Update",
      style: TextStyle(
        fontSize: _fontSize18,
        fontWeight: FontWeight.bold,
      ),
    );
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
        borderRadius: _borderRadius,
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _amber,
      padding: _paddingVertical,
      shape: const RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      elevation: _elevation,
    );
  }
}