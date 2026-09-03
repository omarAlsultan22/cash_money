import '../../../../core/data/models/message_result.dart';
import 'package:cash_money/core/presentation/states/base/main_loaded_state.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';


class DataSuccessStateModel extends LoadedState{
  final QuestionsData questionsData;
  final MessageResult messageResult;

  const DataSuccessStateModel({
    required this.questionsData,
    required this.messageResult,
  });
}