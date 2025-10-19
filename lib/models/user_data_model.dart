import 'answer_model.dart';
import 'json_model.dart';


class QuestionModel implements JsonModel{
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'isChecked': isChecked,
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}



