import 'package:cash_money/features/questions/constants/questions_text_styles.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/icon_button_widget.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import 'package:cash_money/core/constants/app_spaces.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import '../../../../../core/constants/app_paddings.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../answer_button.dart';
import 'dart:async';


class BuildStartScreen extends StatefulWidget {
  final VoidCallback loadMoreData;
  final CacheHelper cacheHelper;
  final void Function(int) onSave;
  final QuestionsData questionsData;
  final MessageResult? messageResult;
  final ConnectivityService connectivityService;

  const BuildStartScreen({
    super.key,
    this.messageResult,
    required this.onSave,
    required this.loadMoreData,
    required this.cacheHelper,
    required this.questionsData,
    required this.connectivityService
  });

  @override
  State<BuildStartScreen> createState() => _BuildStartScreenState();
}

class _BuildStartScreenState extends State<BuildStartScreen> {

  Timer? _timer;
  int _timeLeft = 1;
  bool _colors = false;
  String? _userName;

  //counters
  late int _points;
  late int _currentIndex;

  static const _imageSize = 24.0;
  static const _defaultPaddingValue = 20.0;

  void _startTimer(int length) {
    _timer?.cancel();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) {
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
      widget.loadMoreData();
    }
  }

  Future<void> _isCurrentIndexEquivalent({
    required int length,
    required bool isCorrect,
  }) async {
    final isConnected = await widget.connectivityService
        .checkInternetConnection();

    final isFinished = _currentIndex > length / 2;
    final answers = _points < 2 ? 'answer' : 'answers';
    final text = isConnected
        ? 'You achieved $_points correct $answers out of $length'
        : 'Sorry, your points could not be saved';
    final type = isConnected ? isFinished
        ? QuickAlertType.success
        : QuickAlertType.error : QuickAlertType.error;
    final title = isConnected
        ? isFinished ? 'Congratulations' : 'Try again'
        : AppStrings.noInternetMessage;

    if (isCorrect) {
      QuickAlert.show(
          context: context,
          text: text,
          type: type,
          title: title,
          showConfirmBtn: true,
          confirmBtnText: 'Okay'
      ).whenComplete(() {
        Navigator.pop(context);
        _savePoints(_points);
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
          isCorrect: _currentIndex < length - 1 &&
              widget.questionsData.hasMore);

      _startTimer(length);
    });
  }

  void _initCounters() {
    _points = 0;
    _currentIndex = 0;
  }

  Future<void> _getUserName() async {
    _userName = await widget.cacheHelper.getString(key: 'userName') ?? 'Sir';
    setState(() => _userName);
  }

  void _savePoints(int points) {
    widget.onSave(points);
  }

  @override
  void initState() {
    super.initState();
    _initCounters();
    _colors = false;
    _getUserName();
  }

  @override
  void didUpdateWidget(covariant BuildStartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showMessageResult(widget.messageResult);
      });
      setState(() {});
    }
  }

  void _showMessageResult(MessageResult? messageResult) {
    BuildSnackBar.show(
        context: context,
        message: messageResult!.message!,
        backgroundColor: messageResult.color!
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.brown_900,
        elevation: AppSizes.none,
        title: const Text(
            'Starting',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.white
            )
        ),
        leading: const IconButtonWidget()
    );
  }

  Widget _widgetBuilder() {
    final currentQuestion = widget.questionsData.getCurrentQuestion(
        _currentIndex);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.brown_800,
        appBar: _buildAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.brown_900,
                AppColors.brown_700
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _defaultPaddingValue,
                vertical: _defaultPaddingValue),
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
                                fontSize: 18.0,
                                color: AppColors.white.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                              text: _userName,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.waving_hand_sharp,
                                  color: AppColors.amber_500,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: AppColors.brown_900,
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$_points',
                            style: QuestionsTextStyles.textStyle,
                          ),
                          const SizedBox(width: 5.0),
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
                AppSpaces.vertical_40,
                // Question Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: AppColors.brown_600,
                  child: Padding(
                    padding: AppPaddings.medium,
                    child: Text(currentQuestion,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.amberAccent,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AppSpaces.vertical_30,
                // Answers Section
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: widget.questionsData.getCurrentAnswers(
                        _currentIndex)
                        .map((e) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0),
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
    return _widgetBuilder();
  }
}