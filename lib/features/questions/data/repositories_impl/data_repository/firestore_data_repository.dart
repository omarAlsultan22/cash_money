import '../../../../../core/data/data_sources/remote/firebase_firestore.dart';
import '../../../../../core/presentation/utils/helpers/data_converter.dart';
import '../../../domain/repositories/app_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/questions_result.dart';


class FirestoreDataRepository implements AppDataRepository {
  @override
  Future<GetQuestionsResult> getData({
    required DocumentSnapshot? lastDocument,
    required int limit
  }) async {
    try {
      Query query = FirestoreService.getCollection(
        superCollectionPath: 'data',
        docId: '0Hv1zUWKuetw3eP7Nplt',
        subCollectionPath: 'userData',
      );

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.limit(limit + 1).get();

      if (snapshot.docs.isEmpty) {
        return const GetQuestionsResult(
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

      return GetQuestionsResult(
        questions: questions,
        lastDocument: newLastDocument,
        hasMore: hasMore,
      );
    } catch (e) {
      rethrow;
    }
  }
}