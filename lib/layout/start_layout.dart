import 'package:cash_money/shared/components/constatnts.dart';
import 'package:cash_money/shared/cubit/cubit.dart';
import 'package:cash_money/shared/cubit/state.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class BuildStartScreen extends StatefulWidget {
  final BuildContext context;
  final AppDataStates state;
  const BuildStartScreen({super.key, required this.context, required this.state});

  @override
  State<BuildStartScreen> createState() => _BuildStartScreenState();
}

class _BuildStartScreenState extends State<BuildStartScreen> {

  Timer? timer;
  int timeLeft = 1;
  bool colors = false;
  late AppDataCubit cubit;

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
          if (cubit.currentIndex < length) {
            cubit.currentIndex++;
          }
          timeLeft = 1;
        });
      }
    });
  }

  void questionIndex(bool isCorrect, int length) {
    if (cubit.currentIndex >= length) return;

    setState(() {
      colors = false;
      colors = true;
      if (isCorrect) {
        cubit.points++;
      }
      if (cubit.currentIndex < length) {
        startTimer(length);
      }
      if (cubit.currentIndex == length) {
        bool isFinished = cubit.currentIndex > length / 2;
        String value = cubit.points < 2 ? 'اجابة' : 'اجابات';
        QuickAlert.show(
            context: context,
            text: 'لقد حققت $cubit.points $value صحيحة من أصل $length',
            type: isFinished ? QuickAlertType.success : QuickAlertType.error,
            title: isFinished ? 'تهانينا' : 'حاول مجددا',
            showConfirmBtn: true,
            confirmBtnText: 'حسنا'
        ).whenComplete(() {
          Navigator.pop(context);
          cubit.resetQuiz();
        });
        timer?.cancel();
      }
      else if (cubit.currentIndex == length - 1 && !cubit.isLoadingMore) {
        cubit.getData(key: Screens.start);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cubit = AppDataCubit.get(widget.context);
    cubit.currentIndex = 0;
    colors = false;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  AppBar _buildAppBar(){
    return AppBar(
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
    );
  }

  Widget _widgetBuilder(){
    final questionsData = cubit.questionsData;
    return questionsData.isNotEmpty
        ? Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.brown[800],
        appBar: _buildAppBar(),
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
                            '${cubit.points}',
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
                        questionsData[cubit.currentIndex].question,
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
                    children: questionsData[cubit.currentIndex].answers.map((e) =>
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
                                    e.isCorrect, questionsData.length - 1),
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
  }

  @override
  Widget build(BuildContext context) {
    return _widgetBuilder();
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