import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/core/domain/data_sources/firestore_service.dart';

class FakeFirestoreService implements FirestoreService {
  // ===== setData =====
  int setDataCallCount = 0;
  String? lastDocId;
  String? lastCollectionPath;
  Map<String, dynamic>? lastData;
  Object? setDataError;

  // ===== getCollection =====
  Query<Map<String, dynamic>>? queryToReturn;
  int getCollectionCallCount = 0;
  String? lastSuperCollectionPath;
  String? lastSubCollectionPath;
  String? lastGetCollectionDocId;

  // ===== getDocument =====
  DocumentSnapshot<Map<String, dynamic>>? documentToReturn;
  Object? getDocumentError;

  @override
  Future<void> setData({
    required String docId,
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    setDataCallCount++;
    lastDocId = docId;
    lastCollectionPath = collectionPath;
    lastData = data;
    if (setDataError != null) throw setDataError!;
  }

  @override
  Query<Map<String, dynamic>> getCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath,
  }) {
    getCollectionCallCount++;
    lastSuperCollectionPath = superCollectionPath;
    lastSubCollectionPath = subCollectionPath;
    lastGetCollectionDocId = docId;
    return queryToReturn!;
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String? docId,
    required String collectionPath,
  }) async {
    if (getDocumentError != null) throw getDocumentError!;
    return documentToReturn!;
  }

  @override
  Future<void> updateDocument({
    required String? docId,
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async => throw UnimplementedError();
}