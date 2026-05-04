import 'package:cash_money/features/questions/data/models/answer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';


class QuestionsData {
  final bool hasMore;
  final List<QuestionModel> questions;
  final DocumentSnapshot? lastDocument;

  const QuestionsData({
    this.questions = const[],
    this.hasMore = true,
    this.lastDocument,
  });

  int get length => questions.length;

  bool get listIsEmpty => questions.isEmpty;

  QuestionModel getQuestionModel(int index) => questions[index];

  String getCurrentQuestion(int currentIndex) => questions[currentIndex].question;

  List<AnswerModel> getCurrentAnswers(int currentIndex) => questions[currentIndex].answers;

  QuestionsData copyWith({
    bool? hasMore,
    List<QuestionModel>? questions,
    DocumentSnapshot? lastDocument
  }) {
    return QuestionsData(
        hasMore: hasMore ?? this.hasMore,
        questions: questions ?? this.questions,
        lastDocument: lastDocument ?? this.lastDocument
    );
  }
}