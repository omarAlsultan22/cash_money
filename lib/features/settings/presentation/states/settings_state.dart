import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import 'package:cash_money/core/presentation/states/app_sup_states.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/states/loaded_states.dart';
import 'package:cash_money/core/data/models/user_model.dart';


class SettingsState extends DoubleModelAppState<UserModel, MessageResult> {
  SettingsState({
    super.firstModel,
    super.secondModel,
    required super.subState
  });

  UserModel? get userModel => firstModel;

  factory SettingsState.initial(){
    return SettingsState(
        firstModel: null,
        secondModel: MessageResult.initial(),
        subState: InitialState()
    );
  }

  @override
  SettingsState copyWith({
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
    required R Function(DoubleModelSuccessState) onLoaded,
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