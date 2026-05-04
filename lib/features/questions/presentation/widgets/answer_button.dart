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

  //spaces
  static const _dx = AppSizes.none;
  static const _dy = 2.0;

  //sizes
  static const _radius = AppSizes.radius;
  static const _elevation = AppSizes.none;

  static const _blurRadius = 4.0;
  static const _opacityDegree = 0.2;

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
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(_opacityDegree),
            blurRadius: _blurRadius,
            offset: const Offset(_dx, _dy),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          padding: AppPaddings.symmetricVertical,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          elevation: _elevation,
        ),
        onPressed: _showCorrectAnswer,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            widget.answer!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSize_18,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}