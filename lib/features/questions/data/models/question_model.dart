import 'package:hive/hive.dart';
import 'answer_model.dart';
part 'question_model.g.dart';


@HiveType(typeId: 0)
class QuestionModel {

  @HiveField(0)
  final String question;

  @HiveField(1)
  final List<AnswerModel> answers;

  QuestionModel({
    required this.question,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List;
    List<AnswerModel> answerList = answersFromJson.map((answerJson) =>
        AnswerModel.fromJson(answerJson)).toList();

    return QuestionModel(
      question: json['question'],
      answers: answerList,
    );
  }
}



