import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';


class GetQuestionsResult {
  final List<QuestionModel> questions;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const GetQuestionsResult({
    required this.questions,
    required this.lastDocument,
    required this.hasMore,
  });

  bool get listIsNotEmpty =>  questions.isEmpty;
}