import '../../cubits/data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../states/questions_state.dart';
import '../../../../../core/presentation/widgets/connection_banner.dart';
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
      backgroundColor: Colors.brown[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          splashRadius: 20,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            color: isCorrect ? Colors.green[800] : Colors.red[800],
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

  @override
  void initState() {
    super.initState();
    cubit = DataCubit.get(context);
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50.0 &&
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
        backgroundColor: Colors.brown[800],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
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
            splashRadius: 20,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.brown[600],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 8),
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
              bgColor: widget.isConnected ? Colors.green.shade700 : Colors.red
                  .shade700,
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


