import '../models/questions_result.dart';
import '../converters/data_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/app_data_repository.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:cash_money/features/questions/data/converters/points_converter.dart';


class FirestoreDataRepository implements AppDataRepository {
  final FirestoreService _repository;
  final SessionService _sessionService;

  FirestoreDataRepository({
    required FirestoreService repository,
    required SessionService sessionService
  })
      : _repository = repository,
        _sessionService = sessionService;

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
        collectionPath: 'points', docId: _sessionService.currentUid);
    return PointsConverter
        .fromQuerySnapshot(doc)
        .points;
  }

  @override
  Future<void> putPoints({required int points}) async {
    await _repository.setData(
        docId: _sessionService.currentUid,
        collectionPath: 'points',
        data: {'points': points});
  }
}