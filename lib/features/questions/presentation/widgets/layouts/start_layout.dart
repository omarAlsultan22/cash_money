import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/presentation/widgets/app_spacing.dart';
import 'package:cash_money/core/constants/app_numbers.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import '../../../../../core/constants/app_paddings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import '../../states/start_state.dart';
import '../../cubits/data_cubit.dart';
import 'dart:async';


class BuildStartScreen extends StatefulWidget {
  final int points;
  final bool hasMore;
  final int currentIndex;
  final bool isConnected;
  final List<QuestionModel> questions;
  const BuildStartScreen({
    super.key,
    required this.points,
    required this.hasMore,
    required this.questions,
    required this.isConnected,
    required this.currentIndex,
  });

  @override
  State<BuildStartScreen> createState() => _BuildStartScreenState();
}

class _BuildStartScreenState extends State<BuildStartScreen> {

  Timer? _timer;
  int _timeLeft = 1;
  bool _colors = false;
  late DataCubit _cubit;

  //numbers
  static const _twenty = AppNumbers.twenty;

  //colors
  static const _white = AppColors.white;
  static const _brown800 = AppColors.brown_800;
  static const _brown900 = AppColors.brown_900;

  void _startTimer(int length) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          _colors = false;
          if (widget.currentIndex < length) {
            final state = StartScreenState();
            _cubit.incrementCurrentIndex(state);
          }
          _timeLeft = 1;
        });
      }
    });
  }

  void _isCurrentIndexSmaller({
    required bool isCorrect,
    required StartScreenState state,
  }) {
    if (isCorrect) {
      _cubit.getData(state);
      return;
    }
  }

  void _isCurrentIndexEquivalent({
    required int length,
    required bool isCorrect,
    required StartScreenState state
  }) {
    const tow = 2;

    if (isCorrect) {
      bool isFinished = widget.currentIndex > length / tow;
      String answers = widget.points < tow ? 'answer' : 'answers';
      QuickAlert.show(
          context: context,
          text: 'You achieved ${widget.points} correct $answers out of $length',
          type: isFinished ? QuickAlertType.success : QuickAlertType.error,
          title: isFinished ? 'Congratulations' : 'Try again',
          showConfirmBtn: true,
          confirmBtnText: 'Okay'
      ).whenComplete(() {
        Navigator.pop(context);
        _cubit.resetQuiz(state);
      });
      _timer?.cancel();
      return;
    }
  }

  void _questionIndex(bool isCorrect, int length) {
    if (widget.currentIndex >= length) return;

    final state = StartScreenState();

    setState(() {
      _colors = false;
      _colors = true;
      if (isCorrect) {
        _cubit.incrementPoints(state);
      }

      _isCurrentIndexEquivalent(
          state: state,
          length: length,
          isCorrect: widget.currentIndex == length
      );

      _isCurrentIndexSmaller(
          state: state,
          isCorrect: widget.currentIndex < length - 1);

      _startTimer(length);
    });
  }

  @override
  void initState() {
    super.initState();
    _cubit = context.read<DataCubit>();
    _colors = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: AppNumbers.zero,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: _white),
        onPressed: () => Navigator.of(context).pop(),
        splashRadius: _twenty,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _brown900,
              _brown800,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _widgetBuilder() {
    const twentyFour = 24.0;
    final userName = CacheHelper.getValue(key: 'name');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _brown800,
        appBar: _buildAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _brown900,
                AppColors.brown_700
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Header Section
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome ',
                              style: TextStyle(
                                fontSize: 18,
                                color: _white.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                              text: '$userName ',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _white,
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.waving_hand_sharp,
                                  color: AppColors.amber_500,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _brown900,
                        borderRadius: BorderRadius.circular(_twenty),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${widget.points}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: _white,
                            ),
                          ),
                          AppSpacing.height_8,
                          Image.asset(
                            'assets/images/icon.png',
                            width: twentyFour,
                            height: twentyFour,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.height_40,
                // Question Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: AppColors.brown_600,
                  child: Padding(
                    padding: AppPaddings.paddingAll_20,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        widget.questions[widget.currentIndex].question,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.amberAccent,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Answers Section
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: widget.questions[widget.currentIndex].answers
                        .map((e) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8),
                          child: AnswerButton(
                            answer: e.answer,
                            isCorrect: e.isCorrect,
                            color: _colors
                                ? (e.isCorrect
                                ? AppColors.green800
                                : AppColors.red800)
                                : const Color(0xFF795548),
                            onTaP: () =>
                                _questionIndex(
                                    e.isCorrect, widget.questions.length - 1),
                          ),
                        ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ConnectionBanner(
              isVisible: widget.isConnected,
              bgColor: widget.isConnected ? AppColors.green700 : AppColors
                  .red700,
              icon: widget.isConnected ? Icons.wifi : Icons.signal_wifi_off,
              text: widget.isConnected ? 'online' : 'offline'
          ),
          Expanded(
              child: _widgetBuilder()
          )
        ]
    );
  }
}


class AnswerButton extends StatelessWidget {
  final String? answer;
  final bool? isCorrect;
  final Color? color;
  final Function? onTaP;

  const AnswerButton({
    Key? key,
    this.answer,
    this.isCorrect,
    this.color,
    this.onTaP,
  }) : super(key: key);

  static const twelve = AppNumbers.twelve;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(twelve),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: AppPaddings.paddingVertical,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(twelve),
          ),
          elevation: AppNumbers.zero,
        ),
        onPressed: () => onTaP?.call(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            answer!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}