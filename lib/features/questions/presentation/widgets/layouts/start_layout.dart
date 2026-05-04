import 'package:cash_money/features/questions/data/models/questions_result.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/data/models/start_model.dart';
import '../../../../../core/presentation/widgets/icon_button_widget.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import 'package:cash_money/core/constants/app_spaces.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import '../../../../../core/constants/app_paddings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import '../../cubits/data_cubit.dart';
import '../answer_button.dart';
import 'dart:async';


class BuildStartScreen extends StatefulWidget {
  final bool isConnected;
  final GameState gameState;
  final VoidCallback getData;
  final CacheHelper cacheHelper;
  final QuestionsData questionsData;

  const BuildStartScreen({
    super.key,
    required this.getData,
    required this.gameState,
    required this.isConnected,
    required this.cacheHelper,
    required this.questionsData
  });

  @override
  State<BuildStartScreen> createState() => _BuildStartScreenState();
}

class _BuildStartScreenState extends State<BuildStartScreen> {

  Timer? _timer;
  int _timeLeft = _seconds;
  bool _colors = false;
  late DataCubit _cubit;
  String? _userName;

  //counters
  late int _points;
  late int _currentIndex;

  //spaces
  static const _vertical8 = 8.0;
  static const _vertical6 = 8.0;
  static const _horizontal = 12.0;
  static const _widgetPadding = 5.0;
  static const _leadingPadding = 5.0;
  static const _questionHeight = 1.3;
  static const _boxShadowOffsetY = 2.0;
  static const _defaultPaddingValue = 20.0;

  //values
  static const _tow = 2;
  static const _seconds = AppDurations.oneSecond;

  //degrees
  static const _opacityDegree02 = 0.2;
  static const _opacityDegree08 = 0.8;

  //colors
  static const _white = AppColors.white;
  static const _brown800 = AppColors.brown_800;
  static const _brown900 = AppColors.brown_900;

  //sizes
  static const _iconSize = 20.0;
  static const _imageSize = 24.0;
  static const _smallFontSize = 18.0;
  static const _titleFontSize = 24.0;
  static const _questionFontSize = 24.0;
  static const _richTextFontSize = 18.0;
  static const _userNameFontSize = 20.0;
  static const _cardBorderRadius = 15.0;
  static const _boxShadowBlurRadius = 4.0;
  static const _borderRadius = AppSizes.radius;

  void _startTimer(int length) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: _seconds), (timer) {
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
        if (_currentIndex < length) {
          setState(() {
            _currentIndex ++;
          });
        }
      }
    });
  }

  void _isCurrentIndexSmaller({
    required bool isCorrect,
  }) {
    if (isCorrect) {
      widget.getData();
    }
  }

  void _isCurrentIndexEquivalent({
    required int length,
    required bool isCorrect,
  }) {
    if (isCorrect) {
      bool isFinished = _currentIndex > length / _tow;
      String answers = _points < _tow ? 'answer' : 'answers';
      QuickAlert.show(
          context: context,
          text: 'You achieved $_points correct $answers out of $length',
          type: isFinished ? QuickAlertType.success : QuickAlertType.error,
          title: isFinished ? 'Congratulations' : 'Try again',
          showConfirmBtn: true,
          confirmBtnText: 'Okay'
      ).whenComplete(() {
        Navigator.pop(context);
        _resetQuiz();
      });
      _timer?.cancel();
      return;
    }
  }

  void _questionIndex(bool isCorrect, int length) {
    if (_currentIndex >= length) return;

    setState(() {
      _colors = false;
      _colors = true;
      if (isCorrect) {
        setState(() {
          _points ++;
        });
      }

      _isCurrentIndexEquivalent(
          length: length,
          isCorrect: _currentIndex == length && !widget.questionsData.hasMore
      );

      _isCurrentIndexSmaller(
          isCorrect: _currentIndex < length - 1 && widget.questionsData.hasMore);

      _startTimer(length);
    });
  }

  void _initCounters() {
    _points = widget.gameState.points;
    _currentIndex = widget.gameState.currentIndex;
  }

  void _resetQuiz() {
    _cubit.resetQuiz();
  }

  @override
  Future<void> initState() async {
    super.initState();
    _initCounters();
    _colors = false;
    _cubit = context.read<DataCubit>();
    _userName = await widget.cacheHelper.getValue(key: 'userName') ?? 'Sir';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: _brown900,
        elevation: AppSizes.none,
        title: const Text(
            'Starting',
            style: TextStyle(
                fontSize: _titleFontSize,
                fontWeight: FontWeight.bold,
                color: _white
            )
        ),
        leading: const IconButtonWidget()
    );
  }

  Widget _widgetBuilder() {
    final currentQuestion = widget.questionsData.getCurrentQuestion(widget.gameState.currentIndex);
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
                horizontal: _defaultPaddingValue, vertical: _defaultPaddingValue),
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
                                fontSize: _richTextFontSize,
                                color: _white.withOpacity(_opacityDegree08),
                              ),
                            ),
                            TextSpan(
                              text: _userName,
                              style: const TextStyle(
                                fontSize: _userNameFontSize,
                                fontWeight: FontWeight.bold,
                                color: _white,
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: _leadingPadding),
                                child: Icon(
                                  Icons.waving_hand_sharp,
                                  color: AppColors.amber_500,
                                  size: _iconSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: _horizontal, vertical: _vertical6),
                      decoration: BoxDecoration(
                        color: _brown900,
                        borderRadius: BorderRadius.circular(_borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(_opacityDegree02),
                            blurRadius: _boxShadowBlurRadius,
                            offset: const Offset(0, _boxShadowOffsetY),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$_points',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _smallFontSize,
                              color: _white,
                            ),
                          ),
                          const SizedBox(width: _widgetPadding),
                          Image.asset(
                            'assets/images/icon.png',
                            width: _imageSize,
                            height: _imageSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpaces.height_40,
                // Question Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_cardBorderRadius),
                  ),
                  color: AppColors.brown_600,
                  child: Padding(
                    padding: AppPaddings.medium,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(currentQuestion,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _questionFontSize,
                          color: Colors.amberAccent,
                          height: _questionHeight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                AppSpaces.height_30,
                // Answers Section
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: widget.questionsData.getCurrentAnswers(widget.gameState.currentIndex)
                        .map((e) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: _vertical8),
                          child: AnswerButton(
                            answer: e.answer,
                            isCorrect: e.isCorrect,
                            color: _colors
                                ? (e.isCorrect
                                ? AppColors.successGreen
                                : AppColors.errorRed)
                                : const Color(0xFF795548),
                            onTaP: () =>
                                _questionIndex(
                                    e.isCorrect,
                                    widget.questionsData.length - 1),
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
          ),
          Expanded(
              child: _widgetBuilder()
          )
        ]
    );
  }
}