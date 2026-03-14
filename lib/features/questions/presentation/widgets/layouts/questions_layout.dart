import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../core/constants/app_numbers.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/presentation/widgets/app_spacing.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/presentation/widgets/icon_button_widget.dart';
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
    const white = AppColors.white;
    const paddingForAll = EdgeInsets.all(20.0);

    return Scaffold(
      backgroundColor: AppColors.brown_900,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: AppNumbers.zero,
        leading: const IconButtonWidget()
      ),
      body: Center(
        child: Padding(
          padding: paddingForAll,
          child: Card(
            elevation: 8,
            color: isCorrect ? AppColors.green800 : AppColors.red800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: paddingForAll,
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: white,
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
  final VoidCallback getData;
  final List<QuestionModel> questions;
  const BuildQuestionsScreen({
    super.key,
    required this.getData,
    required this.hasMore,
    required this.questions,
    required this.isConnected,
    });

  @override
  State<BuildQuestionsScreen> createState() => _BuildQuestionsScreenState();
}

class _BuildQuestionsScreenState extends State<BuildQuestionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - AppNumbers.fifty &&
        widget.hasMore) {
      widget.getData;
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
    const paddingForAll = EdgeInsets.all(16.0);
    const twelve = AppNumbers.twelve;
    const zero = AppNumbers.zero;
    const white = Colors.white;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.brown_800,
        appBar: AppBar(
            backgroundColor: AppColors.transparent,
            scrolledUnderElevation: zero,
            elevation: zero,
            title: const Text(
              'Questions ',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
            leading: const IconButtonWidget()
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.brown_900,
                AppColors.brown_700,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: paddingForAll,
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
                  color: AppColors.brown_600,
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
                      padding: paddingForAll,
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber_500,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: widget.hasMore
                      ? const CircularProgressIndicator(color: white)
                      : const SizedBox(),
                );
              }
            },
            separatorBuilder: (context, index) =>
            AppSpacing.height_8,
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

