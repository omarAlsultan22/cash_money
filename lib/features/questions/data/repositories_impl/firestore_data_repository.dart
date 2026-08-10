import '../models/questions_result.dart';
import '../converters/data_converter.dart';
import '../../../../core/constants/app_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/app_data_repository.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:cash_money/features/questions/data/converters/points_converter.dart';


class FirestoreDataRepository implements AppDataRepository {
  final FirestoreService _repository;

  FirestoreDataRepository({
    required FirestoreService repository
  })
      : _repository = repository;

  @override
  Future<QuestionsData> getData({
    required DocumentSnapshot? lastDocument,
    required int limit
  }) async {
    try {
      Query query = _repository.getCollection(
        superCollectionPath: 'data',
        docId: '0Hv1zUWKuetw3eP7Nplt',
        subCollectionPath: 'userData',
      );

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.limit(limit).get().timeout(
          AppDurations.seconds);

      if (snapshot.docs.isEmpty) {
        return const QuestionsData(
          questions: [],
          lastDocument: null,
          hasMore: false,
        );
      }

      final docs = snapshot.docs;
      final newLastDocument = docs.isNotEmpty ? docs.last : null;

      final questions = DataConverter
          .fromQuerySnapshot(snapshot)
          .data;

      return QuestionsData(
        questions: questions,
        lastDocument: newLastDocument,
        hasMore: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int?> getPoints() async {
    final doc = await _repository.getDocument(
        collectionPath: 'points', docId: AppKeys.uId);
    return PointsConverter
        .fromQuerySnapshot(doc)
        .points;
  }

  @override
  Future<void> putPoints({required int points}) async {
    await _repository.setData(
        docId: AppKeys.uId, collectionPath: 'points', data: {'points': points});
  }
}