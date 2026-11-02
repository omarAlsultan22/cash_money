import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/core/domain/data_sources/firestore_service.dart';


/// Fake مخصص لـ SettingsRepositoryImpl.
/// يغطي فقط getDocument و updateDocument (اللتان يستخدمهما SettingsRepositoryImpl).
class FakeSettingsDataSource implements FirestoreService {
  // ===== getDocument =====
  DocumentSnapshot<Map<String, dynamic>>? documentToReturn;
  Object? getDocumentError;
  int getDocumentCallCount = 0;
  String? lastGetDocId;
  String? lastGetCollectionPath;

  // ===== updateDocument =====
  int updateCallCount = 0;
  String? lastUpdateDocId;
  String? lastUpdateCollectionPath;
  Map<String, dynamic>? lastUpdateData;
  Object? updateError;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String? docId,
    required String collectionPath,
  }) async {
    getDocumentCallCount++;
    lastGetDocId = docId;
    lastGetCollectionPath = collectionPath;
    if (getDocumentError != null) throw getDocumentError!;
    return documentToReturn!;
  }

  @override
  Future<void> updateDocument({
    required String? docId,
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    updateCallCount++;
    lastUpdateDocId = docId;
    lastUpdateCollectionPath = collectionPath;
    lastUpdateData = data;
    if (updateError != null) throw updateError!;
  }

  // دوال غير مستخدمة في SettingsRepositoryImpl — ترمي بوضوح
  @override
  Future<void> setData({
    required String docId,
    required String collectionPath,
    required Map<String, dynamic> data,
  }) =>
      throw UnimplementedError('setData not stubbed in FakeSettingsDataSource');

  @override
  Query<Map<String, dynamic>> getCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath,
  }) =>
      throw UnimplementedError(
          'getCollection not stubbed in FakeSettingsDataSource');
}