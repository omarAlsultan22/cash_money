import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/state.dart';

class AnswerScreen extends StatelessWidget {
  final String answer;
  final bool isCorrect;

  const AnswerScreen({
    Key? key,
    required this.answer,
    required this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class BuildQuestionsScreen extends StatefulWidget {
  final BuildContext context;
  final AppDataStates state;
  const BuildQuestionsScreen({
    super.key,
    required this.context,
    required this.state,
  });

  @override
  State<BuildQuestionsScreen> createState() => _BuildQuestionsScreenState();
}

class _BuildQuestionsScreenState extends State<BuildQuestionsScreen> {
  final ScrollController _scrollController = ScrollController();
  late AppDataCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = AppDataCubit.get(widget.context);
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50.0 &&
        !cubit.isLoadingMore) {
      cubit.getQuestionsData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state is AppDataLoadingState && widget.state.key == Screens.questions) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
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

    final questions = cubit
        .questionsData;

    return widget.state is AppDataSuccessState && widget.state.key == Screens.questions
        ? Directionality(
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
                  child: !cubit.isLoadingMore
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                );
              }
            },
            separatorBuilder: (context, index) =>
            const SizedBox(height: 8),
          ),
        ),
      ),
    )
        : const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
      ),
    );
  }
}


