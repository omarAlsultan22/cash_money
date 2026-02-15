import 'dart:async';
import '../states/base/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/questions_params.dart';
import 'package:cash_money/core/errors/error_handler.dart';
import '../../domain/useCases/questions_data_useCase.dart';
import 'package:cash_money/core/errors/exceptions/app_exception.dart';


class DataCubit extends Cubit<DataState> {
  final QuestionsDataUseCase _questionsDataUseCase;

  DataCubit({
    required QuestionsDataUseCase questionsDataUseCase,
  })
      : _questionsDataUseCase = questionsDataUseCase,
        super(const DataState());

  static DataCubit get(context) => BlocProvider.of(context);

  void restLock(DataState dataState) {
    emit(dataState.updateState(hasMore: true, questions: state.questions, ));
  }

  void resetQuiz(DataState dataState) {
    emit(dataState.updateState(
        points: 0,
        currentIndex: 0)
    );
  }

  void incrementPoints(DataState dataState) {
    emit(dataState.updateState(
        points: dataState.points + 1,
        questions: state.questions)
    );
  }

  void incrementCurrentIndex(DataState dataState) {
    emit(dataState.updateState(
        currentIndex: dataState.currentIndex + 1,
        questions: state.questions)
    );
  }

  Future<void> getData(DataState dataState) async {
    if (!state.hasMore) return;
    final appState = dataState.appState;
    try {
      final result = await _questionsDataUseCase.execute(params:
      GetQuestionsParams(
        lastDocument: state.lastDocument,
      ));

      emit(dataState.updateState(
          questions: [...state.questions, ...result!.questions],
          lastDocument: result.lastDocument,
          hasMore: result.hasMore,
          appState: appState!.copyWith(isLoading: false)
      ));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      final newAppState = appState!.copyWith(
          isLoading: false, failure: exception);
      emit(dataState.updateState(appState: newAppState));
    }
  }
}
