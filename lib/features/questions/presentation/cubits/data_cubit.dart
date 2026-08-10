import 'dart:async';
import '../states/data_state.dart';
import '../enums/questions_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/questions_params.dart';
import '../../domain/useCases/questions_data_useCase.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/domain/useCases/points_useCase.dart';


class DataCubit extends Cubit<DataState> with ErrorHandlerMixin<DataState> {
  final CacheHelper _cacheHelper;
  final PointsUseCase _pointsUseCase;
  final ConnectivityService _connectivityService;
  final QuestionsDataUseCase _questionsDataUseCase;

  DataCubit({
    required CacheHelper cacheHelper,
    required PointsUseCase pointsUseCase,
    required ConnectivityService connectivityService,
    required QuestionsDataUseCase questionsDataUseCase
  })
      : _cacheHelper = cacheHelper,
        _pointsUseCase = pointsUseCase,
        _questionsDataUseCase = questionsDataUseCase,
        _connectivityService = connectivityService,
        super(
          DataState.initial()
      );

  static DataCubit get(context) => BlocProvider.of(context);

  Future<void> putPoints({required int points}) async {
    final value = await _cacheHelper.getInt(key: 'points');
    if (value == null) {
      await _pointsUseCase.putPointsExecute(points: points);
    }
  }

  Future<void> getPoints() async {
    final points = await _pointsUseCase.getPointsExecute();
    if(points != null) {
      _cacheHelper.setInt(key: 'points', value: points);
    }
  }

  Future<void> _fetchData() async {
    try {
      final newData = await _questionsDataUseCase.execute(
          questions: state.questions,
          params: GetQuestionsParams(
            lastDocument: state.lastDocument,
          )
      );

      if (newData!.listIsEmpty && state.listIsEmpty) {
        emit(state.copyWith(subState: const InitialState()));
        return;
      }

      emit(state.copyWith(
          firstModel: newData,
          subState: const SuccessState())
      );
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> getData(QuestionsKeys? key) async {
    if (!state.listIsEmpty) return;

    final isConnected = await _connectivityService.checkInternetConnection();

    if (!isConnected) {
      emit(
          state.copyWith(
              subState: ErrorState(
                  failure: NetworkAppException(
                      error: AppStrings.noInternetMessage))
          )
      );
      return;
    }
    emit(
        state.copyWith(
            key: key,
            subState: const LoadingState())
    );
    try {
      _fetchData();
    }
    catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      failure: failure
                  )
              )
      );
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
}
