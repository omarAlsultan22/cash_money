import 'package:cash_money/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_model.dart';


class DataModel {
  List<QuestionModel> data;
  DataModel({required this.data});

  factory DataModel.fromQuerySnapshot(QuerySnapshot snapshot) {
    List<QuestionModel> data = [];
    for (var doc in snapshot.docs) {
      final docData = doc.data() as Map<String, dynamic>;
      final answers = (docData['answers'] as List).map((e) => AnswerModel.fromJson(e)).toList();
      final question = docData['question'] as String;
      final isChecked = docData['isChecked'] as bool;

      data.add(QuestionModel(
        question: question,
        isChecked: isChecked,
        answers: answers,
      ));
    }
    return DataModel(data: data);
  }
}