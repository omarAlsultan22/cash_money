import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import 'package:cash_money/core/presentation/states/app_sup_states.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/states/loaded_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/questions_result.dart';
import '../../data/models/question_model.dart';
import '../enums/questions_keys.dart';


class DataState extends DoubleModelAppState<QuestionsData, MessageResult> {
  final QuestionsKeys? key;

  DataState({
    this.key,
    required super.subState,
    required super.firstModel,
    required super.secondModel,
  });

  factory DataState.initial(){
    return DataState(
        key: null,
        subState: const InitialState(),
        firstModel: const QuestionsData(),
        secondModel: MessageResult.initial()
    );
  }

  bool get hasMore => firstModel!.hasMore;

  bool get listIsEmpty => firstModel!.listIsEmpty;

  List<QuestionModel> get questions => firstModel!.questions;

  DocumentSnapshot? get lastDocument => firstModel!.lastDocument;

  QuestionsData updateData({
    bool? hasMore,
    List<QuestionModel>? questions,
    DocumentSnapshot? lastDocument
  }) =>
      firstModel!.copyWith(
          hasMore: hasMore,
          questions: questions,
          lastDocument: lastDocument
      );

  @override
  DataState copyWith({
    QuestionsKeys? key,
    QuestionsData? firstModel,
    MessageResult? secondModel,
    MainAppSubState? subState
  }) =>
      DataState(
          key: key ?? this.key,
          subState: subState ?? this.subState,
          firstModel: firstModel ?? this.firstModel,
          secondModel: secondModel ?? this.secondModel
      );

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(DoubleModelSuccessState) onLoaded,
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