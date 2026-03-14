import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';
import '../../../../../core/presentation/widgets/icon_button_widget.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/presentation/widgets/app_spacing.dart';
import '../../../../../core/presentation/states/app_state.dart';
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
  final VoidCallback getData;
  final List<QuestionModel> questions;
  const BuildStartScreen({
    super.key,
    required this.points,
    required this.hasMore,
    required this.getData,
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

  //counters
  late int points;
  late int currentIndex;

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
          _timeLeft = 1;
        });
        if (currentIndex < length) {
          final state = StartScreenState(appState: const AppState());
          _cubit.incrementCurrentIndex(state, currentIndex);
        }
      }
    });
  }

  void _isCurrentIndexSmaller({
    required bool isCorrect,
  }) {
    if (isCorrect) {
      widget.getData;
    }
  }

  void _isCurrentIndexEquivalent({
    required int length,
    required bool isCorrect,
  }) {
    const tow = 2;

    if (isCorrect) {
      bool isFinished = currentIndex > length / tow;
      String answers = points < tow ? 'answer' : 'answers';
      QuickAlert.show(
          context: context,
          text: 'You achieved $points correct $answers out of $length',
          type: isFinished ? QuickAlertType.success : QuickAlertType.error,
          title: isFinished ? 'Congratulations' : 'Try again',
          showConfirmBtn: true,
          confirmBtnText: 'Okay'
      ).whenComplete(() {
        Navigator.pop(context);
      });
      _timer?.cancel();
      return;
    }
  }

  void _questionIndex(bool isCorrect, int length) {
    if (currentIndex >= length) return;

    setState(() {
      _colors = false;
      _colors = true;
      if (isCorrect) {
        final state = StartScreenState(appState: const AppState());
        _cubit.incrementPoints(state, points);
      }

      _isCurrentIndexEquivalent(
          length: length,
          isCorrect: currentIndex == length && !widget.hasMore
      );

      _isCurrentIndexSmaller(
          isCorrect: currentIndex < length - 1 && widget.hasMore);

      _startTimer(length);
    });
  }

  void _initCounters() {
    points = widget.points;
    currentIndex = widget.currentIndex;
  }

  void _resetQuiz() {
    final state = StartScreenState(appState: const AppState());
    _cubit.resetQuiz(state);
  }

  @override
  void initState() {
    super.initState();
    _initCounters();
    _cubit = context.read<DataCubit>();
    _colors = false;
  }

  @override
  void didUpdateWidget(covariant BuildStartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points) {
      setState(() {
        points = widget.points;
      });
    }
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        currentIndex = widget.currentIndex;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _resetQuiz();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: _brown900,
        elevation: AppNumbers.zero,
        title: const Text(
            'Starting',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: _white
            )
        ),
        leading: const IconButtonWidget()
    );
  }

  Widget _widgetBuilder() {
    const twentyFour = 24.0;

    return FutureBuilder(
      future: CacheHelper.getValue(key: 'userName'),
      builder: (context, snapshot) {
        String userName = snapshot.data?.toString() ?? 'Sir';
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
                    horizontal: 20.0, vertical: 20.0),
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
                                  text: userName,
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
                                '$points',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _white,
                                ),
                              ),
                              const SizedBox(width: 5.0),
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
                            widget.questions[currentIndex].question,
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
                        children: widget.questions[currentIndex].answers
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