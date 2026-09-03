import '../../../../core/data/models/message_result.dart';
import 'package:cash_money/core/presentation/states/base/main_loaded_state.dart';
import 'package:cash_money/features/questions/data/models/questions_result.dart';


class DataSuccessState extends LoadedState{
  final QuestionsData questionsData;
  final MessageResult messageResult;

  const DataSuccessState({
    required this.questionsData,
    required this.messageResult,
  });
}