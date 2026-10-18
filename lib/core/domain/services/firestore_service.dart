import 'package:cloud_firestore/cloud_firestore.dart';


abstract class FirestoreService {
  Future<void> setData({
    required String docId,
    required String collectionPath,
    required Map<String, dynamic> data
  });

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String? docId,
    required String collectionPath
  });

  Query<Map<String, dynamic>> getCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath
  });

  Future<void> updateDocument({
    required String? docId,
    required String collectionPath,
    required Map<String, dynamic> data
  });
}