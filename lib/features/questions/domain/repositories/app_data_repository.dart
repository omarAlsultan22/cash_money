import '../../data/models/questions_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class AppDataRepository {
  Future<QuestionsData?> getData({
    required DocumentSnapshot? lastDocument,
    required int limit
  });
}