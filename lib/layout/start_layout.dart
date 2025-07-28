import 'dart:async';
import 'package:cash_money/shared/components/constatnts.dart';
import 'package:cash_money/shared/cubit/cubit.dart';
import 'package:cash_money/shared/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Timer? timer;
  int timeLeft = 1;
  int points = 0;
  bool colors = false;
  int currentIndex = 0;

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
          if (currentIndex < length) {
            currentIndex++;
          }
          timeLeft = 1;
        });
      }
    });
  }

  void questionIndex(bool isCorrect, int length) {
    if (currentIndex >= length) return;

    setState(() {
      colors = false;
      colors = true;
      if (isCorrect) {
        points++;
      }
      if (currentIndex < length) {
        startTimer(length);
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    colors = false;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppDataCubit()
        ..getData(),
      child: BlocConsumer<AppDataCubit, AppDataStates>(
        listener: (context, state) {
          if (state is AppDataErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red[800],
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = AppDataCubit
              .get(context)
              .dataList;
          return state is AppDataListSuccessState
              ? Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.brown[800],
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  splashRadius: 20,
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown[900]!,
                        Colors.brown[800]!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown[900]!,
                      Colors.brown[700]!,
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
                                    text: '${UserDetails.name} ',
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
                              color: Colors.brown[900],
                              borderRadius: BorderRadius.circular(20),
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
                                  '$points',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  'assets/images/icon.png',
                                  width: 24,
                                  height: 24,
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
                        color: Colors.brown[600],
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              cubit[currentIndex].question,
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
                          children: cubit[currentIndex].answers.map((e) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                child: AnswerButton(
                                  answer: e.answer,
                                  isCorrect: e.isCorrect,
                                  color: colors
                                      ? (e.isCorrect
                                      ? Colors.green[800]
                                      : Colors.red[800])
                                      : Colors.brown[500],
                                  onTaP: () =>
                                      questionIndex(
                                          e.isCorrect, cubit.length - 1),
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
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading Questions...',
                  style: TextStyle(
                    color: Colors.brown[200],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
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