import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String question;
  final bool isChecked;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.question,
    required this.isChecked,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List;
    List<AnswerModel> answerList = answersFromJson.map((answerJson) => AnswerModel.fromJson(answerJson)).toList();

    return QuestionModel(
      question: json['question'],
      isChecked: json['isChecked'],
      answers: answerList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'isChecked': isChecked,
      'answers': answers.map((e) => e.toMap()).toList(),
    };
  }
}

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

  Map<String, dynamic> toMap() {
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

