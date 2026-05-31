import '../../../../../core/presentation/utils/helpers/validate/validator_input.dart';
import '../../../../auth/presentation/screens/change_email_and_password_screen.dart';
import 'package:cash_money/core/presentation/widgets/icon_button_widget.dart';
import 'package:cash_money/core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/text_form_field.dart';
import '../../../../../core/presentation/widgets/loading_widget.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import 'package:cash_money/core/constants/app_text_styles.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import 'package:cash_money/core/constants/app_strings.dart';
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

  static const _paddingVertical = AppPaddings.verticalSymmetric;
  static const _roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)));

  @override
  void initState() {
    super.initState();
    _initializeControllers(
        userName: widget.userModel.userName,
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
    super.dispose();
  }

  void _initializeControllers({
    required String? userName,
  }) {
    _nameController.text = userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.brown_900,
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
              AppSpaces.vertical_32,
              _buildNameField(),
              AppSpaces.vertical_24,
              _buildChangePasswordButton(),
              AppSpaces.vertical_16,
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
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: AppColors.amber_400,
          ),
        ),
        AppSpaces.vertical_8,
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
    return _buildCustomInputField(
      controller: _nameController,
      label: AppStrings.nameLabel,
      hint: AppStrings.nameHint,
      icon: Icons.person,
      validator: (value) => ValidateInput.validator(value, AppStrings.nameLabel),
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
        AppSpaces.vertical_8,
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
            fontSize: AppSizes.fontSize_18,
            color: AppColors.amber_600,
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
      style: AppTextStyles.textStyle,
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
        AppColors.brown_900,
          AppColors.brown_800,
        ],
      ),
    );
  }

  ButtonStyle _changePasswordButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: _paddingVertical,
      side: const BorderSide(color: AppColors.amber_600),
      shape: _roundedRectangleBorder,
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.amber_600,
      padding: _paddingVertical,
      shape: _roundedRectangleBorder,
      elevation: 4.0,
    );
  }
}