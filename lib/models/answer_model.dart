import 'package:cash_money/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/models/json_model.dart';


class AnswerModel implements JsonModel{
  final String answer;
  final bool isCorrect;

  AnswerModel(this.answer, this.isCorrect);

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      json['answer'],
      json['isCorrect'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'isCorrect': isCorrect,
    };
  }
}

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