import 'package:cash_money/core/constants/app_durations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;
  static const _duration = AppDurations.seconds;

  // إضافة بيانات مع إنشاء معرف تلقائي
  Future<String> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final docRef = await _firestore.collection(collectionPath).add(data).timeout(_duration);
    return docRef.id;
  }

  // إضافة بيانات بمعرف محدد
  Future<void> setData({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionPath).doc(docId).set(data).timeout(_duration);
  }

  // الحصول على مستند محدد
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String? docId,
  }) async {
    return await _firestore.collection(collectionPath).doc(docId).get().timeout(_duration);
  }

  Query<Map<String, dynamic>> getCollection({
    required String docId,
    required String subCollectionPath,
    required String superCollectionPath,
  }) {
    return _firestore
        .collection(superCollectionPath)
        .doc(docId)
        .collection(subCollectionPath);
  }

  // تحديث مستند محدد
  Future<void> updateDocument({
    required String collectionPath,
    required String? docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionPath).doc(docId).update(data).timeout(_duration);
  }

  // حذف مستند محدد
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    await _firestore.collection(collectionPath).doc(docId).delete().timeout(_duration);
  }
}