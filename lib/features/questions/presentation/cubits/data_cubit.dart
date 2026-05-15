import 'dart:async';
import '../states/data_state.dart';
import '../enums/questions_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/questions_params.dart';
import 'package:cash_money/core/errors/mappers/error_handler.dart';
import '../../domain/useCases/questions_data_useCase.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import '../../../../core/errors/exceptions/network_exception.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class DataCubit extends Cubit<DataState> {
  final QuestionsDataUseCase _questionsDataUseCase;
  final ConnectivityProvider _connectivityProvider;

  DataCubit({
    required QuestionsDataUseCase questionsDataUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _questionsDataUseCase = questionsDataUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          DataState(
              subState: InitialState()
          )
      );

  static DataCubit get(context) => BlocProvider.of(context);

  void startMonitoring() {
    _connectivityProvider.addListener(_handleConnectionChange);
  }

  void _handleConnectionChange() {
    if (_connectivityProvider.isConnected && state.listIsEmpty) {
      restLock();
      getData(state.key);
    }
  }

  void restLock() {
    final questions = state.copyWithQuestions(hasMore: true);
    emit(
        state.updateState(firstModel: questions)
    );
  }

  void resetQuiz() {
    final startModel = state.copyWithStart(
        points: 0,
        currentIndex: 0
    );
    emit(
        state.updateState(
            secondModel: startModel
        )
    );
  }

  void incrementPoints(int points) {
    final startModel = state.copyWithStart(
        points: points
    );
    emit(state.updateState(secondModel: startModel)
    );
  }

  void incrementCurrentIndex(int currentIndex) {
    final startModel = state.copyWithStart(
        currentIndex: currentIndex
    );
    emit(state.updateState(
        secondModel: startModel)
    );
  }

  Future<void> _fetchData()async {
    try {
      final result = await _questionsDataUseCase.execute(params:
      GetQuestionsParams(
        lastDocument: state.lastDocument,
      ));

      emit(state.updateState(
          firstModel: result,
          subState: SuccessState())
      );
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> getData(QuestionsKeys? key) async {
    if (!state.listIsEmpty) return;

    if (!_connectivityProvider.isConnected) {
      emit(
          state.updateState(
              subState: ErrorState(
                  failure: NetworkException(
                      error: AppStrings.noInternetMessage))
          )
      );
      return;
    }
    emit(
        state.updateState(
            key: key,
            subState: LoadingState())
    );
    try {
      _fetchData();
    }
    on AppException catch (e, stackTrace) {
      final exception =  ErrorHandler(error: e, stackTrace: stackTrace).handleException();
      emit(state.updateState(subState: ErrorState(failure: exception)));
    }
  }

  Future<void> loadMoreData() async {
    if (!state.hasMore) return;
    try {
      _fetchData();
    }
    catch (e) {
      Future.delayed(const Duration(seconds: 3), () {
        loadMoreData();
      });
    }
  }

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(_handleConnectionChange);
    return super.close();
  }
}
