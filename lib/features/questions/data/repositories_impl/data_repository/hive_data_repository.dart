import '../../../../../core/data/data_sources/local/hive.dart';
import '../../../domain/repositories/app_data_repository.dart';
import '../../../domain/repositories/data_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/questions_result.dart';


class HiveDataRepository implements AppDataRepository, DataOperations {
  @override
  Future<GetQuestionsResult?> getData({
    DocumentSnapshot? lastDocument,
    required int limit
  }) async {
    try {
      final result = await HiveOperations.getLocalData(lastDocument);

      if (result == null) return null;

      if (result is List<GetQuestionsResult>) {
        return result;
      }

      if (result is List) {
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> putData({
    required GetQuestionsResult result
  }) async {
    try {
      await HiveOperations.putLocalData(result: result);
    }
    catch (e) {
      rethrow;
    }
  }
}