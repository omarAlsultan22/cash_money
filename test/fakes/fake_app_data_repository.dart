import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';
import 'package:cash_money/features/questions/domain/repositories/app_data_repository.dart';


class FakeAppDataRepository implements AppDataRepository {
  QuestionsData? getDataResult;
  Object? getDataError;

  int getDataCallCount = 0;
  DocumentSnapshot? lastDocument;
  int? lastLimit;

  @override
  Future<QuestionsData> getData({
    required DocumentSnapshot? lastDocument,
    required int limit,
  }) async {
    getDataCallCount++;
    this.lastDocument = lastDocument;
    lastLimit = limit;
    if (getDataError != null) throw getDataError!;
    return getDataResult!;
  }

  // ===== putPoints =====
  int putPointsCallCount = 0;
  int? lastPutPoints;
  Object? putPointsError;

  @override
  Future<void> putPoints({required int points}) async {
    putPointsCallCount++;
    lastPutPoints = points;
    if (putPointsError != null) throw putPointsError!;
  }

  // ===== getPoints =====
  int getPointsCallCount = 0;
  int? getPointsResult;
  Object? getPointsError;

  @override
  Future<int?> getPoints() async {
    getPointsCallCount++;
    if (getPointsError != null) throw getPointsError!;
    return getPointsResult;
  }
}