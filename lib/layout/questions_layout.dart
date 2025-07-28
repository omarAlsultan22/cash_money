import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
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
          if (state is AppDataLoadingState) {
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

          final questions = AppDataCubit
              .get(context)
              .dataList;

          return state is AppDataListSuccessState
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}