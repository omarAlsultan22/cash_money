import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../screens/answer_screen.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_spaces.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
import 'package:cash_money/core/presentation/widgets/icon_button_widget.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';


class BuildQuestionsScreen extends StatefulWidget {
  bool isLoading;
  final bool isConnected;
  final VoidCallback getData;
  final QuestionsData questionsData;
  BuildQuestionsScreen({
    super.key,
    required this.getData,
    required this.isLoading,
    required this.isConnected,
    required this.questionsData
  });

  @override
  State<BuildQuestionsScreen> createState() => _BuildQuestionsScreenState();
}

class _BuildQuestionsScreenState extends State<BuildQuestionsScreen> {
  final ScrollController _scrollController = ScrollController();

  static const _white = Colors.white;

  static const _elevation = AppSizes.none;

  //sizes
  static const _borderRadius = AppSizes.radius;

  //spaces
  static const _paddingValue = 16.0;
  static const _paddingForAll = EdgeInsets.all(_paddingValue);
  static const _specificPosition = AppSizes.medium;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - _specificPosition &&
        widget.questionsData.hasMore && !widget.isLoading) {
      widget.isLoading = true;
      widget.getData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  Widget _widgetBuilder() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.brown_800,
        appBar: AppBar(
            backgroundColor: AppColors.transparent,
            scrolledUnderElevation: _elevation,
            elevation: _elevation,
            title: const Text(
              'Questions ',
              style: TextStyle(
                fontSize: AppSizes.fontSize_24,
                fontWeight: FontWeight.bold,
                color: _white,
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
            padding: _paddingForAll,
            itemCount: widget.questionsData.length + 1,
            itemBuilder: (context, index) {
              if (index < widget.questionsData.length) {
                final question = widget.questionsData.getQuestionModel(index);
                final correctAnswer = question.answers.firstWhere(
                      (a) => a.isCorrect,
                  orElse: () => question.answers.first,
                );

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  color: AppColors.brown_600,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(_borderRadius),
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
                      padding: _paddingForAll,
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: AppSizes.fontSize_18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber_500,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: widget.questionsData.hasMore
                      ? const CircularProgressIndicator(color: _white)
                      : const SizedBox(),
                );
              }
            },
            separatorBuilder: (context, index) =>
            AppSpaces.height_8,
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

