import 'answer_model.dart';


class QuestionModel{
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
}



