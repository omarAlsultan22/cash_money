import 'package:cash_money/features/questions/data/models/question_model.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';
import 'package:cash_money/features/questions/domain/use_cases/pagination_state_manager.dart';


class FakePaginationHandler implements PaginationHandler {
  QuestionsData? resultToReturn;
  int updateCallCount = 0;
  List<QuestionModel>? lastQuestions;
  QuestionsData? lastNewData;

  @override
  QuestionsData updateWithNewData(
      List<QuestionModel> questions,
      QuestionsData newData,
      ) {
    updateCallCount++;
    lastQuestions = questions;
    lastNewData = newData;
    return resultToReturn ?? newData;
  }
}