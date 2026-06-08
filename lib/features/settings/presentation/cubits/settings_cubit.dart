import '../states/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/settings_useCase.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import '../../../../core/data/network/connectivity_service.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/presentation/providers/connectivity_provider.dart';


class SettingsCubit extends Cubit<SettingsState> with ErrorHandlerMixin<SettingsState> {
  final SettingsUseCase _settingsUseCase;
  final ConnectivityProvider _connectivityProvider;

  SettingsCubit({
    required SettingsUseCase settingsUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _settingsUseCase = settingsUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          SettingsState.initial());

  static SettingsCubit get(context) => BlocProvider.of(context);

  static const internetUnavailable = AppStrings.noInternetMessage;

  void startMonitoring() {
    _connectivityProvider.addListener(_handleConnectionChange);
  }

  void _handleConnectionChange() {
    if (_connectivityProvider.isConnected && state.userModel == null) {
      getInfo();
    }
  }

  Future<void> updateInfo({
    required String userName,
  }) async {
    SettingsState buildState(MessageResult messageResult) {
      return state.copyWith(
          firstModel: state.userModel,
          secondModel: messageResult,
          subState: SuccessState()
      );
    }
    if (!_connectivityProvider.isConnected) {
      final connectivityService = ConnectivityService();
      emit(
          buildState(
            MessageResult.error(
              error: NetworkAppException(
                  error: internetUnavailable,
                  connectivityService: connectivityService
              ),
            ),
          )
      );
      return;
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
              state.copyWith(secondModel: MessageResult.error(error: failure)
              )
      );
    }
  }

  Future<void> getInfo() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      final connectivityService = ConnectivityService();
      emit(
          state.copyWith(
            subState: ErrorState(
              failure: NetworkAppException(
                  error: internetUnavailable,
                  connectivityService: connectivityService
              ),
            ),
          )
      );
      return;
    }
    emit(
        state.copyWith(
            subState: LoadingState()));

    try {
      final userModel = await _settingsUseCase.getInfoExecute();
      emit(
          state.copyWith(
              firstModel: userModel,
              subState: SuccessState()));
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

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(_handleConnectionChange);
    return super.close();
  }
}
