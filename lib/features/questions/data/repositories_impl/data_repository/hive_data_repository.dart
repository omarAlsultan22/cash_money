import '../../../../../core/data/data_sources/local/hive.dart';
import '../../../domain/repositories/app_data_repository.dart';
import '../../../domain/repositories/data_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/questions_result.dart';


class HiveDataRepository implements AppDataRepository, DataOperations {
  @override
  Future<GetQuestionsResult?> getData({
    required DocumentSnapshot lastDocument,
    required int limit
  }) async {
    try {
      final result = await HiveOperations.getLocalData(lastDocument);

      if (result == null) return null;

      if (result is List<GetQuestionsResult>) {
        print('Get data is done..................data ${result.questions
            .length}');
        return result;
      }

      if (result is List) {
        print('Get data is done..................data');
        return result;
      }

      print('Get data is done..................empty');
      return null;
    } catch (e) {
      print("Error getting local data: $e");
      return null;
    }
  }


  @override
  Future<void> putData({
    required GetQuestionsResult result
  }) async {
    await HiveOperations.putLocalData(result: result);
  }
}