import '../../data/models/questions_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class AppDataRepository {
  Future<GetQuestionsResult?> getData({
    required DocumentSnapshot? lastDocument,
    required int limit
  });
}