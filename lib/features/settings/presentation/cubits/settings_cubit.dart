import '../states/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/settings_useCase.dart';
import '../../../../core/services/connectivity_service.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import 'package:cash_money/core/errors/exceptions/network_app_exception.dart';


class SettingsCubit extends Cubit<SettingsState> with ErrorHandlerMixin<SettingsState> {
  final SettingsUseCase _settingsUseCase;
  final ConnectivityService _connectivityService;

  SettingsCubit({
    required SettingsUseCase settingsUseCase,
    required ConnectivityService connectivityService
  })
      : _settingsUseCase = settingsUseCase,
        _connectivityService = connectivityService,
        super(
          SettingsState.initial());

  static SettingsCubit get(context) => BlocProvider.of(context);

  Future<void> updateInfo({
    required String userName,
  }) async {
    SettingsState buildState(MessageResult messageResult) {
      return state.copyWith(
          firstModel: state.userModel,
          secondModel: messageResult,
          subState: const SuccessState()
      );
    }

    final isConnected = await _connectivityService.checkInternetConnection();

    if (!isConnected) {
      throw NetworkAppException();
    }

    emit(buildState(MessageResult.loading()));

    try {
      await _settingsUseCase.updateInfoExecute(
        userName: userName,
      );

      emit(buildState(MessageResult.success()));
    }
    catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              buildState(
                  MessageResult.error(
                    error: failure,
                  )
              )
      );
    }
  }

  Future<void> getInfo() async {
    final isConnected = await _connectivityService.checkInternetConnection();

    if (!isConnected && state.firstModel == null) {
      throw NetworkAppException();
    }
    emit(
        state.copyWith(
            subState: const LoadingState()));

    try {
      final userModel = await _settingsUseCase.getInfoExecute();
      emit(
          state.copyWith(
              firstModel: userModel,
              subState: const SuccessState()));
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
}
