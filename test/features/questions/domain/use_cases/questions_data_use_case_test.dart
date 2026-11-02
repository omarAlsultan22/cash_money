import 'package:cash_money/features/questions/domain/use_cases/questions_data_use_case.dart';
import 'package:cash_money/features/questions/data/models/questions_params.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../../../fakes/fake_app_data_repository.dart';
import '../../../../fakes/mock_pagination_handler.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  late FakeAppDataRepository fakeRepo;
  late FakePaginationHandler fakePagination;
  late QuestionsDataUseCase useCase;
  late FakeFirebaseFirestore fakeFirestore;

  final q1 = QuestionModel(question: 'Q1', answers: []);
  final q2 = QuestionModel(question: 'Q2', answers: []);

  setUp(() {
    fakeRepo = FakeAppDataRepository();
    fakePagination = FakePaginationHandler();
    fakeFirestore = FakeFirebaseFirestore();
    useCase = QuestionsDataUseCase(
      repository: fakeRepo,
      paginationHandler: fakePagination,
    );
  });

  group('execute', () {
    test('passes lastDocument and limit to repository.getData', () async {
      await fakeFirestore.collection('x').doc('d1').set({'a': 1});
      final doc = await fakeFirestore.collection('x').doc('d1').get();

      final params = GetQuestionsParams(lastDocument: doc, limit: 20);
      fakeRepo.getDataResult = const QuestionsData(
        questions: [],
        lastDocument: null,
        hasMore: false,
      );

      await useCase.execute(questions: [q1], params: params);

      expect(fakeRepo.getDataCallCount, 1);
      expect(fakeRepo.lastDocument, same(doc));
      expect(fakeRepo.lastLimit, 20);
    });

    test('passes questions and newData to paginationHandler', () async {
      final newData = QuestionsData(
        questions: [q2],
        lastDocument: null,
        hasMore: true,
      );
      fakeRepo.getDataResult = newData;
      const params = GetQuestionsParams(lastDocument: null, limit: 10);

      await useCase.execute(questions: [q1], params: params);

      expect(fakePagination.updateCallCount, 1);
      expect(fakePagination.lastQuestions, [q1]);
      expect(fakePagination.lastNewData, same(newData));
    });

    test('returns the result from paginationHandler', () async {
      final newData = QuestionsData(
        questions: [q2],
        lastDocument: null,
        hasMore: true,
      );
      final expected = QuestionsData(
        questions: [q1, q2],
        lastDocument: null,
        hasMore: true,
      );
      fakeRepo.getDataResult = newData;
      fakePagination.resultToReturn = expected;

      final result = await useCase.execute(
        questions: [q1],
        params: const GetQuestionsParams(lastDocument: null, limit: 10),
      );

      expect(result, same(expected));
    });

    test('propagates errors from repository.getData', () async {
      fakeRepo.getDataError = Exception('network failed');

      expect(
            () => useCase.execute(
          questions: [q1],
          params: const GetQuestionsParams(lastDocument: null, limit: 10),
        ),
        throwsA(isA<Exception>()),
      );

      // paginationHandler لم يُستدعَ
      expect(fakePagination.updateCallCount, 0);
    });

    test('handles empty questions list', () async {
      final newData = QuestionsData(
        questions: [q1, q2],
        lastDocument: null,
        hasMore: true,
      );
      fakeRepo.getDataResult = newData;

      final result = await useCase.execute(
        questions: [],
        params: const GetQuestionsParams(lastDocument: null, limit: 10),
      );

      expect(fakePagination.lastQuestions, isEmpty);
      expect(result, same(newData));
    });

    test('passes null lastDocument when params.lastDocument is null',
            () async {
          fakeRepo.getDataResult = const QuestionsData(
            questions: [],
            lastDocument: null,
            hasMore: false,
          );

          await useCase.execute(
            questions: [],
            params: const GetQuestionsParams(lastDocument: null, limit: 5),
          );

          expect(fakeRepo.lastDocument, isNull);
          expect(fakeRepo.lastLimit, 5);
        });
  });
}