import 'package:cloud_firestore/cloud_firestore.dart';


class GetQuestionsParams {
  final DocumentSnapshot? lastDocument;
  final int limit;

  const GetQuestionsParams({
    this.lastDocument,
    this.limit = 10
  });
}