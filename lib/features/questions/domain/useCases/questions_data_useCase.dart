import '../../data/models/questions_params.dart';
import '../../data/models/questions_result.dart';
import '../repositories/app_data_repository.dart';


class QuestionsDataUseCase {
  final AppDataRepository _repository;

  QuestionsDataUseCase({
    required AppDataRepository repository,
  })
      :
        _repository = repository;


  Future<QuestionsData?> execute({
    required GetQuestionsParams params
  }) async {
    try {
      return _repository.getData(
          lastDocument: params.lastDocument,
          limit: params.limit
      );
    }
    catch (e) {
      rethrow;
    }
  }
}


