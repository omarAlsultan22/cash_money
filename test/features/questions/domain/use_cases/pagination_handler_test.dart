import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cash_money/features/questions/data/models/question_model.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';
import 'package:cash_money/features/questions/domain/use_cases/pagination_state_manager.dart';


void main() {
  late PaginationHandler handler;
  late FakeFirebaseFirestore fakeFirestore;

  final q1 = QuestionModel(question: 'Q1', answers: []);
  final q2 = QuestionModel(question: 'Q2', answers: []);
  final q3 = QuestionModel(question: 'Q3', answers: []);
  final q4 = QuestionModel(question: 'Q4', answers: []);

  setUp(() {
    handler = PaginationHandler();
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('updateWithNewData', () {
    test('appends new questions after existing ones (order preserved)',
            () async {
          final previous = [q1, q2];
          final newData = QuestionsData(
            questions: [q3, q4],
            lastDocument: null,
            hasMore: true,
          );

          final result = handler.updateWithNewData(previous, newData);

          expect(result.questions, [q1, q2, q3, q4]);
        });

    test('returns newData.questions when previous is empty', () async {
      final newData = QuestionsData(
        questions: [q1, q2],
        lastDocument: null,
        hasMore: false,
      );

      final result = handler.updateWithNewData([], newData);

      expect(result.questions, [q1, q2]);
    });

    test('keeps previous questions when newData.questions is empty', () async {
      final previous = [q1, q2];
      const newData = QuestionsData(
        questions: [],
        lastDocument: null,
        hasMore: false,
      );

      final result = handler.updateWithNewData(previous, newData);

      expect(result.questions, [q1, q2]);
    });

    test('returns empty list when both are empty', () async {
      const newData = QuestionsData(
        questions: [],
        lastDocument: null,
        hasMore: false,
      );

      final result = handler.updateWithNewData([], newData);

      expect(result.questions, isEmpty);
    });

    test('uses hasMore from newData (not from previous)', () async {
      final previous = [q1];
      final newData = QuestionsData(
        questions: [q2],
        lastDocument: null,
        hasMore: false,  // ← من newData
      );

      final result = handler.updateWithNewData(previous, newData);

      expect(result.hasMore, false);
    });

    test('uses lastDocument from newData', () async {
      await fakeFirestore.collection('x').doc('d1').set({'a': 1});
      final doc = await fakeFirestore.collection('x').doc('d1').get();

      final previous = [q1];
      final newData = QuestionsData(
        questions: [q2],
        lastDocument: doc,
        hasMore: true,
      );

      final result = handler.updateWithNewData(previous, newData);

      expect(result.lastDocument, same(doc));
    });

    test('does not modify the original previous list', () async {
      final previous = [q1, q2];
      final originalLength = previous.length;
      final newData = QuestionsData(
        questions: [q3],
        lastDocument: null,
        hasMore: true,
      );

      handler.updateWithNewData(previous, newData);

      // previous لم يتغير
      expect(previous.length, originalLength);
      expect(previous, [q1, q2]);
    });

    test('does not modify the original newData.questions list', () async {
      final newQuestions = [q3, q4];
      final newData = QuestionsData(
        questions: newQuestions,
        lastDocument: null,
        hasMore: true,
      );

      handler.updateWithNewData([q1], newData);

      // newData.questions لم يتغير
      expect(newQuestions, [q3, q4]);
    });
  });
}