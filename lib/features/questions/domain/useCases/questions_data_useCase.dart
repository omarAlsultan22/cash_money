import '../../data/models/questions_params.dart';
import '../../data/models/questions_result.dart';
import '../repositories/app_data_repository.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';
import 'package:cash_money/features/questions/presentation/utils/helpers/pagination_state_manager.dart';


class QuestionsDataUseCase {
  final AppDataRepository _repository;
  final PaginationHandler _paginationHandler;

  QuestionsDataUseCase({
    required AppDataRepository repository,
    required PaginationHandler paginationHandler
  })
      :
        _repository = repository,
        _paginationHandler = paginationHandler;


  Future<QuestionsData?> execute({
    required List<QuestionModel> questions,
    required GetQuestionsParams params
  }) async {
    try {
      final newData = await _repository.getData(
          lastDocument: params.lastDocument,
          limit: params.limit
      );
      return _paginationHandler.updateWithNewData(questions, newData);
    }
    catch (e) {
      rethrow;
    }
  }
}


