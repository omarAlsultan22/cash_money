import '../models/questions_result.dart';
import '../converters/data_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/app_data_repository.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../../../../core/domain/data_sources/firestore_service.dart';
import 'package:cash_money/features/questions/data/converters/points_converter.dart';


class AppDataRepositoryImpl implements AppDataRepository {
  final FirestoreService _dataSource;
  final SessionService _sessionService;

  AppDataRepositoryImpl({
    required FirestoreService dataSource,
    required SessionService sessionService
  })
      : _dataSource = dataSource,
        _sessionService = sessionService;

  @override
  Future<QuestionsData> getData({
    required DocumentSnapshot? lastDocument,
    required int limit
  }) async {
      Query query = _dataSource.getCollection(
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
  }

  @override
  Future<int?> getPoints() async {
    final doc = await _dataSource.getDocument(
        collectionPath: 'points', docId: _sessionService.currentUid);
    return PointsConverter
        .fromQuerySnapshot(doc)
        .points;
  }

  @override
  Future<void> putPoints({required int points}) async {
    await _dataSource.setData(
        docId: _sessionService.currentUid,
        collectionPath: 'points',
        data: {'points': points});
  }
}