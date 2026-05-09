import 'package:cash_money/features/questions/constants/questions_text_styles.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class AnswerButton extends StatefulWidget {
final Color? color;
final String? answer;
final bool? isCorrect;
final Function? onTaP;

const AnswerButton({
Key? key,
required this.color,
required this.onTaP,
required this.answer,
required this.isCorrect,
}) : super(key: key);

@override
State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {

  bool _isLoading = false;

  static final _borderRadius = BorderRadius.circular(AppSizes.radius);

  void _showCorrectAnswer() {
    if (_isLoading) return;
    setState(() =>
    _isLoading = true);
    widget.onTaP?.call();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: AppDurations.millSeconds),
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(AppSizes.none, 2.0),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          padding: AppPaddings.symmetricVertical,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
          ),
          elevation: AppSizes.none,
        ),
        onPressed: _showCorrectAnswer,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            widget.answer!,
            style: QuestionsTextStyles.textStyle,
          ),
        ),
      ),
    );
  }
}