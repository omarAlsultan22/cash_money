import '../../../../../core/errors/exceptions/app_exception.dart';
import '../../../../../core/presentation/states/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/question_model.dart';


class DataState {
  final int points;
  final bool hasMore;
  final int currentIndex;
  final AppState? appState;
  final DocumentSnapshot? lastDocument;
  final List<QuestionModel> questions;

  const DataState({
    this.appState,
    this.hasMore = true,
    this.points = 0,
    this.currentIndex = 0,
    this.lastDocument,
    this.questions = const [],
  });

  bool get _isLoading => appState!.isLoading;

  AppException? get _failure => appState!.failure;

  bool get dataIsEmpty => questions.isEmpty;

  DataState updateState({
    bool? hasMore,
    int? points,
    int? currentIndex,
    AppState? appState,
    DocumentSnapshot? lastDocument,
    List<QuestionModel>? questions,
  }) {
    return DataState(
        appState: appState ?? this.appState,
        hasMore: hasMore ?? this.hasMore,
        points: points ?? this.points,
        currentIndex: currentIndex ?? this.currentIndex,
        lastDocument: lastDocument ?? this.lastDocument,
        questions: questions ?? this.questions
    );
  }

  R map<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(List<QuestionModel> data) onLoaded,
    required R Function(AppException error) onError,
  }) {
    if (_failure != null) {
      return onError(_failure!);
    }

    if (_isLoading && questions.isEmpty) {
      return onLoading();
    }

    if (questions.isNotEmpty) {
      return onLoaded(questions);
    }

    return onInitial();
  }
}