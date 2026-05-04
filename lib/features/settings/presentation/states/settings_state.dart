import 'package:cash_money/core/presentation/states/base/main_loaded_state.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/presentation/states/base/main_app_sup_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/states/loaded_states.dart';
import 'package:cash_money/core/data/models/user_model.dart';


class SettingsState extends MainAppSupState<UserModel, MessageResult> {
  SettingsState({
    super.firstModel,
    super.secondModel,
    required super.subState
  });

  UserModel? get userModel => firstModel;

  LoadedState get dataModels =>
      MultiModelSuccessState<UserModel, MessageResult>(
          firstModel: firstModel,
          secondModel: secondModel
      );

  @override
  SettingsState updateState({
    UserModel? firstModel,
    MessageResult? secondModel,
    MainAppSubState? subState
  }) {
    return SettingsState(
        subState: subState ?? this.subState,
        firstModel: firstModel ?? this.firstModel,
        secondModel: secondModel ?? this.secondModel,
    );
  }

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(LoadedState) onLoaded,
    required R Function(AppException) onError
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded.call(dataModels),
        onError: (failure) => onError.call(failure));
  }
}