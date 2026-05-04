import '../../../../../core/data/data_sources/local/hive.dart';
import '../../../domain/repositories/app_data_repository.dart';
import '../../../domain/repositories/data_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/questions_result.dart';


class HiveDataRepository implements AppDataRepository, HiveDataPutter {
  final HiveService _repository;

  HiveDataRepository({
    required HiveService repository
  })
      : _repository = repository;

  @override
  Future<QuestionsData?> getData({
    DocumentSnapshot? lastDocument,
    required int limit
  }) async {
    try {
      final result = await _repository.getLocalData(lastDocument);

      if (result == null) return null;

      if (result is List<QuestionsData>) {
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
    required QuestionsData result
  }) async {
    try {
      await _repository.putLocalData(result: result);
    }
    catch (e) {
      rethrow;
    }
  }
}