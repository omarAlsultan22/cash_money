import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_app_data_repository.dart';
import 'package:cash_money/features/questions/domain/use_cases/points_use_case.dart';


void main() {
  late PointsUseCase useCase;
  late FakeAppDataRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeAppDataRepository();
    useCase = PointsUseCase(repository: fakeRepo);
  });

  group('putPointsExecute', () {
    test('delegates to repository.putPoints with the given points', () async {
      await useCase.putPointsExecute(points: 100);

      expect(fakeRepo.putPointsCallCount, 1);
      expect(fakeRepo.lastPutPoints, 100);
    });

    test('propagates repository errors', () async {
      fakeRepo.putPointsError = Exception('write failed');

      expect(
            () => useCase.putPointsExecute(points: 50),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getPointsExecute', () {
    test('returns points from repository', () async {
      fakeRepo.getPointsResult = 42;

      final result = await useCase.getPointsExecute();

      expect(result, 42);
      expect(fakeRepo.getPointsCallCount, 1);
    });

    test('returns null when repository returns null', () async {
      fakeRepo.getPointsResult = null;

      final result = await useCase.getPointsExecute();

      expect(result, isNull);
    });

    test('propagates repository errors', () async {
      fakeRepo.getPointsError = Exception('read failed');

      expect(
            () => useCase.getPointsExecute(),
        throwsA(isA<Exception>()),
      );
    });
  });
}