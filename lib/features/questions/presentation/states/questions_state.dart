import 'base/data_state.dart';
import '../../data/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/presentation/states/app_state.dart';
import 'package:cash_money/core/errors/exceptions/app_exception.dart';


class QuestionsScreenState extends DataState {
  QuestionsScreenState({
    super.hasMore,
    super.appState,
    super.questions,
    super.lastDocument,
  });

  @override
  DataState updateState({
    int? points,
    bool? hasMore,
    int? currentIndex,
    AppState? appState,
    List<QuestionModel>? questions,
    DocumentSnapshot<Object?>? lastDocument,
  }) {
    return super.updateState(
        hasMore: hasMore ?? super.hasMore,
        appState: appState ?? super.appState,
        questions: questions ?? super.questions,
        lastDocument: lastDocument ?? super.lastDocument
    );
  }

  @override
  R map<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(List<QuestionModel> data) onLoaded,
    required R Function(AppException error) onError}) {
    return super.map(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: onLoaded,
        onError: onError);
  }
}

