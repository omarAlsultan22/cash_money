import '../../../../../core/data/data_sources/remote/firestore.dart';
import '../../../../../core/presentation/utils/helpers/data_converter.dart';
import '../../../domain/repositories/app_data_repository.dart';
import 'package:cash_money/core/constants/app_durations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/questions_result.dart';


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
      final hasMore = snapshot.docs.length > limit;
      final newLastDocument = docs.isNotEmpty ? docs.last : null;

      final questions = DataConverter
          .fromQuerySnapshot(snapshot)
          .data;

      return QuestionsData(
        questions: questions,
        lastDocument: newLastDocument,
        hasMore: hasMore,
      );
    } catch (e) {
      rethrow;
    }
  }
}