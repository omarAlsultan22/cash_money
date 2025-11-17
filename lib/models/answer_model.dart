import 'package:cash_money/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AnswerModel {
  final String answer;
  final bool isCorrect;

  AnswerModel(this.answer, this.isCorrect);

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      json['answer'],
      json['isCorrect'],
    );
  }
}

