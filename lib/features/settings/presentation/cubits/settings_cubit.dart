import '../states/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/useCases/settings_useCase.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/errors/exceptions/network_exception.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class SettingsCubit extends Cubit<SettingsState> {
  final SettingsUseCase _settingsUseCase;
  final ConnectivityProvider _connectivityProvider;

  SettingsCubit({
    required SettingsUseCase settingsUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _settingsUseCase = settingsUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          SettingsState(subState: InitialState()));

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
    required String userPhone,
    required String userLocation
  }) async {
    SettingsState buildState(MessageResult messageResult) {
      return state.updateState(
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
              error: NetworkException(
                  message: internetUnavailable,
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
        userPhone: userPhone,
        userLocation: userLocation,
      );

      emit(buildState(MessageResult.success()));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(buildState(MessageResult.error(error: exception)));
    }
  }

  Future<void> getInfo() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      final connectivityService = ConnectivityService();
      emit(
          state.updateState(
            subState: ErrorState(
              failure: NetworkException(
                message: internetUnavailable,
                connectivityService: connectivityService
              ),
            ),
          )
      );
      return;
    }
    emit(
        state.updateState(
            subState: LoadingState()));

    try {
      final userModel = await _settingsUseCase.getInfoExecute();
      emit(
          state.updateState(
              firstModel: userModel,
              subState: SuccessState()));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(
          state.updateState(
              subState: ErrorState(
                  failure: exception
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
