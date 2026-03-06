import '../../cubits/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../states/questions_state.dart';
import '../../../../../core/constants/numbers_constants.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/presentation/widgets/app_sized_boxes.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';


class AnswerScreen extends StatelessWidget {
  final String answer;
  final bool isCorrect;

  const AnswerScreen({
    Key? key,
    required this.answer,
    required this.isCorrect,
  }) : super(key: key);

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: NumbersConstants.zero,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          splashRadius: NumbersConstants.twenty,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }
}

class BuildQuestionsScreen extends StatefulWidget {
  final bool hasMore;
  final bool isConnected;
  final List<QuestionModel> questions;
  const BuildQuestionsScreen({
    super.key,
    required this.hasMore,
    required this.questions,
    required this.isConnected,
    });

  @override
  State<BuildQuestionsScreen> createState() => _BuildQuestionsScreenState();
}

class _BuildQuestionsScreenState extends State<BuildQuestionsScreen> {
  final ScrollController _scrollController = ScrollController();
  late DataCubit cubit;

  static const zero = NumbersConstants.zero;
  static const twelve = NumbersConstants.twelve;

  @override
  void initState() {
    super.initState();
    cubit = DataCubit.get(context);
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - NumbersConstants.fifty &&
        widget.hasMore) {
      final state = QuestionsScreenState();
      cubit.getData(state);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  Widget _widgetBuilder() {
    final questions = widget.questions;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF4E342E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: zero,
          elevation: zero,
          title: const Text(
            'الأسئلة',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            splashRadius: NumbersConstants.twelve,
          ),
        ),
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
          child: ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: questions.length + 1,
            itemBuilder: (context, index) {
              if (index < questions.length) {
                final question = questions[index];
                final correctAnswer = question.answers.firstWhere(
                      (a) => a.isCorrect,
                  orElse: () => question.answers.first,
                );

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(twelve),
                  ),
                  color: const Color(0xFF6D4C41),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(twelve),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              AnswerScreen(
                                answer: correctAnswer.answer,
                                isCorrect: true,
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: widget.hasMore
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const SizedBox(),
                );
              }
            },
            separatorBuilder: (context, index) =>
            AppSizedBoxes.height_8,
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


