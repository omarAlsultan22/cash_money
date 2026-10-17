import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/core/constants/app_durations.dart';


class FirestoreService {
  static const _duration = AppDurations.seconds;
  static final _firestore = FirebaseFirestore.instance;

  Future<void> setData({
    required String docId,
    required String collectionPath,
    required Map<String, dynamic> data
  }) async {
    await _firestore.collection(collectionPath).doc(docId).set(data).timeout(
        _duration);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String? docId,
    required String collectionPath
  }) async {
    return await _firestore.collection(collectionPath).doc(docId).get().timeout(
        _duration);
  }

  Query<Map<String, dynamic>> getCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath
  }) {
    return _firestore
        .collection(superCollectionPath)
        .doc(docId)
        .collection(subCollectionPath);
  }

  Future<void> updateDocument({
    required String? docId,
    required String collectionPath,
    required Map<String, dynamic> data
  }) async {
    await _firestore.collection(collectionPath).doc(docId).update(data).timeout(
        _duration);
  }
}