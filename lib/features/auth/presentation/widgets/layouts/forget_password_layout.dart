import 'package:cash_money/core/presentation/utils/helpers/validate/validator_input.dart';
import 'package:cash_money/features/auth/constants/auth_lables_texts.dart';
import '../../../../../core/presentation/widgets/build_input_field.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';


class ForgetPasswordLayout extends StatefulWidget {
  final void Function({
  required String userEmail,
  }) onUpdate;
  final MessageResult messageResult;
  const ForgetPasswordLayout({
    super.key,
    required this.onUpdate,
    required this.messageResult
  });

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgetPasswordLayout> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ForgetPasswordLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult.message != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showMessageResult(widget.messageResult);
      });
      setState(() {});
      Navigator.pop(context);
    }
  }

  void _showMessageResult(MessageResult messageResult) {
    BuildSnackBar.show(
        context: context,
        message: messageResult.message!,
        backgroundColor: messageResult.color!
    ).close();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    widget.onUpdate(userEmail: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown_900,
      appBar: AppBar(
          title: const Text('Forget Password', style: TextStyle(color: AppColors.white)),
          backgroundColor: AppColors.transparent
          ,
      ),
      body: Padding(
        padding: AppPaddings.medium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildInputField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: AuthLabelsTexts.emailLabelText,
                border: OutlineInputBorder(),
              ),
              validator: (value) => ValidateInput.validator(value, AuthLabelsTexts.emailLabelText),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendResetEmail,
              child: const Text('Send reset link'),
            ),
          ],
        ),
      ),
    );
  }
}