import 'package:cash_money/features/questions/data/models/data_success_state_model.dart';
import 'package:cash_money/core/presentation/states/base/main_app_sup_state.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/questions_result.dart';
import '../../data/models/question_model.dart';
import '../enums/questions_keys.dart';


class DataState extends MainAppSupState {
  final QuestionsKeys? key;
  final QuestionsData questionsData;
  final MessageResult messageResult;

  const DataState({
    this.key,
    required super.subState,
    required this.questionsData,
    required this.messageResult,
  });

  factory DataState.initial(){
    return DataState(
        key: null,
        subState: const InitialState(),
        questionsData: const QuestionsData(),
        messageResult: MessageResult.initial()
    );
  }

  bool get hasMore => questionsData.hasMore;

  bool get listIsEmpty => questionsData.listIsEmpty;

  List<QuestionModel> get questions => questionsData.questions;

  DocumentSnapshot? get lastDocument => questionsData.lastDocument;

  QuestionsData updateData({
    bool? hasMore,
    List<QuestionModel>? questions,
    DocumentSnapshot? lastDocument
  }) =>
      questionsData.copyWith(
          hasMore: hasMore,
          questions: questions,
          lastDocument: lastDocument
      );

  DataState copyWith({
    QuestionsKeys? key,
    QuestionsData? questionsData,
    MessageResult? messageResult,
    MainAppSubState? subState
  }) =>
      DataState(
          key: key ?? this.key,
          subState: subState ?? this.subState,
          questionsData: questionsData ?? this.questionsData,
          messageResult: messageResult ?? this.messageResult
      );


  @override
  DataSuccessStateModel get dataModels =>
      DataSuccessStateModel(
          questionsData: questionsData, messageResult: messageResult);

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(DataSuccessStateModel) onLoaded,
    required R Function(AppException) onError
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded.call(
                dataModels
            ),
        onError: (failure) => onError.call(failure));
  }
}