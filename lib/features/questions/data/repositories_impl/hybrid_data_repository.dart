import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../domain/repositories/app_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_repository/hive_data_repository.dart';
import '../models/questions_result.dart';


class HybridDataRepository implements AppDataRepository {
  final AppDataRepository _remoteDatabase;
  final HiveDataRepository _localDatabase;
  final ConnectivityService _connectivityService;

  HybridDataRepository({
    required AppDataRepository remoteDatabase,
    required HiveDataRepository localDatabase,
    required ConnectivityService connectivityService
  })
      :
        _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _connectivityService = connectivityService;

  @override
  Future<GetQuestionsResult?> getData({
    required DocumentSnapshot? lastDocument,
    required int limit
  }) async {
    final isConnection = await _connectivityService.checkInternetConnection();
    if (isConnection) {
      final result = await _remoteDatabase.getData(
          lastDocument: lastDocument, limit: limit);

      if(result!.listIsNotEmpty){
        await _localDatabase.putData(
            result: result
        );
      }

      return result;
    }
    return await _localDatabase.getData(
        lastDocument: lastDocument!, limit: limit);
  }
}