import '../states/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/useCases/settings_useCase.dart';
import 'package:cash_money/core/presentation/states/app_state.dart';
import 'package:cash_money/core/errors/exceptions/app_exception.dart';
import 'package:cash_money/core/data/models/message_result_model.dart';


class SettingsCubit extends Cubit<SettingsState> {
  final SettingsUseCase _settingsUseCase;

  SettingsCubit({required SettingsUseCase settingsUseCase})
      : _settingsUseCase = settingsUseCase,
        super(SettingsState(appState: const AppState()));

  static SettingsCubit get(context) => BlocProvider.of(context);


  Future<MessageResultModel> updateInfo({
    required String uId,
    required String userName,
    required String userPhone,
    required String userLocation
  }) async {
    try {
      await _settingsUseCase.updateInfoExecute(
        userName: userName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      return MessageResultModel(isSuccess: true);
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      return MessageResultModel(isSuccess: false, error: exception.message);
    }
  }

  Future<void> getInfo() async {
    final appState = state.appState!;
    emit(state.updateState(appState: appState.copyWith(isLoading: true)));
    try {
      final userModel = await _settingsUseCase.getInfoExecute();
      emit(state.updateState(
          userModel: userModel, appState: appState.copyWith(isLoading: false)));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.updateState(
          appState: appState.copyWith(isLoading: false, failure: exception)));
    }
  }
}
