import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';
import 'package:cash_money/core/presentation/widgets/app_sized_boxes.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/constants/numbers_constants.dart';
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

  Timer? timer;
  int timeLeft = 1;
  bool colors = false;
  late DataCubit cubit;

  static const tow = 2;
  static const twentyFour = 24.0;
  static const twenty = NumbersConstants.twenty;

  void startTimer(int length) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          colors = false;
          if (widget.currentIndex < length) {
            final state = StartScreenState();
            cubit.incrementCurrentIndex(state);
          }
          timeLeft = 1;
        });
      }
    });
  }

  void _isCurrentIndexSmaller({
    required bool isCorrect,
    required StartScreenState state,
  }) {
    if (isCorrect) {
      cubit.getData(state);
      return;
    }
  }

  void _isCurrentIndexEquivalent({
    required int length,
    required bool isCorrect,
    required StartScreenState state
  }) {
    if (isCorrect) {
      bool isFinished = widget.currentIndex > length / tow;
      String value = widget.points < tow ? 'اجابة' : 'اجابات';
      QuickAlert.show(
          context: context,
          text: 'لقد حققت ${widget.points} $value صحيحة من أصل $length',
          type: isFinished ? QuickAlertType.success : QuickAlertType.error,
          title: isFinished ? 'تهانينا' : 'حاول مجددا',
          showConfirmBtn: true,
          confirmBtnText: 'حسنا'
      ).whenComplete(() {
        Navigator.pop(context);
        cubit.resetQuiz(state);
      });
      timer?.cancel();
      return;
    }
  }

  void questionIndex(bool isCorrect, int length) {
    if (widget.currentIndex >= length) return;

    final state = StartScreenState();

    setState(() {
      colors = false;
      colors = true;
      if (isCorrect) {
        cubit.incrementPoints(state);
      }

      _isCurrentIndexEquivalent(
          state: state,
          length: length,
          isCorrect: widget.currentIndex == length
      );

      _isCurrentIndexSmaller(
          state: state,
          isCorrect: widget.currentIndex < length - 1);

      startTimer(length);
    });
  }

  @override
  void initState() {
    super.initState();
    cubit = context.read<DataCubit>();
    colors = false;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: NumbersConstants.zero,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        splashRadius: twenty,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3E2723),
              Color(0xFF4E342E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _widgetBuilder() {
    final userName = CacheHelper.getValue(key: 'name');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF4E342E),
        appBar: _buildAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3E2723),
                Color(0xFF5D4037),
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
                              text: 'مرحباً ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                              text: '$userName ',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.waving_hand_sharp,
                                  color: Colors.amber,
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
                        color: const Color(0xFF3E2723),
                        borderRadius: BorderRadius.circular(twenty),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
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
                              color: Colors.white,
                            ),
                          ),
                          AppSizedBoxes.height_8,
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

                const SizedBox(height: 40),

                // Question Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: const Color(0xFF6D4C41),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                            color: colors
                                ? (e.isCorrect
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828))
                                : const Color(0xFF795548),
                            onTaP: () =>
                                questionIndex(
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
              bgColor: widget.isConnected ? const Color(0xFF388E3C) : const Color(0xFFD32F2F),
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

  static const twelve = NumbersConstants.twelve;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(twelve),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(twelve),
          ),
          elevation: NumbersConstants.zero,
        ),
        onPressed: () => onTaP?.call(),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            answer!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}