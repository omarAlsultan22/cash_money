import '../repositories/app_data_repository.dart';


class PointsUseCase {
  final AppDataRepository _repository;

  PointsUseCase({
    required AppDataRepository repository,
  })
      :
        _repository = repository;


  Future<void> putPointsExecute({required int points}) async {
    await _repository.putPoints(points: points);
  }

  Future<int?> getPointsExecute() async {
    return await _repository.getPoints();
  }
}


