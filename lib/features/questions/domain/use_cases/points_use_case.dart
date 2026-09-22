import '../repositories/app_data_repository.dart';


class PointsUseCase {
  final AppDataRepository _repository;

  PointsUseCase({
    required AppDataRepository repository,
  })
      :
        _repository = repository;


  Future<void> putPointsExecute({required int points}) async {
    try {
      await _repository.putPoints(points: points);
    }
    catch (e) {
      rethrow;
    }
  }

  Future<int?> getPointsExecute() async {
    try {
      return await _repository.getPoints();
    }
    catch (e) {
      rethrow;
    }
  }
}


