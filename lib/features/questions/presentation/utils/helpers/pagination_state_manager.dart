import 'package:cash_money/features/questions/data/models/question_model.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';


class PaginationHandler {
  QuestionsData updateWithNewData(List<QuestionModel> questions,
      QuestionsData newData) {
    final products = [...questions, ...newData.questions];
    return newData.copyWith(
      questions: products,
      hasMore: newData.hasMore,
      lastDocument: newData.lastDocument,
    );
  }
}