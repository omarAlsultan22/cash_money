import 'package:cash_money/core/presentation/states/base/main_app_sup_state.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import 'package:cash_money/core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import '../../data/models/settings_success_state_model.dart';


class SettingsState extends MainAppSupState {
  final UserModel userModel;
  final MessageResult messageResult;

  const SettingsState({
    required this.userModel,
    required this.messageResult,
    required super.subState
  });

  bool get userNameIsEmpty => userModel.isNotEmpty;

  factory SettingsState.initial(){
    return SettingsState(
        userModel: UserModel(),
        messageResult: MessageResult.initial(),
        subState: const InitialState()
    );
  }

  SettingsState copyWith({
    UserModel? userModel,
    MessageResult? messageResult,
    MainAppSubState? subState
  }) {
    return SettingsState(
      subState: subState ?? this.subState,
      userModel: userModel ?? this.userModel,
      messageResult: messageResult ?? this.messageResult,
    );
  }

  @override
  SettingsSuccessStateModel get dataModels =>
      SettingsSuccessStateModel(
          userModel: userModel, messageResult: messageResult);

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(SettingsSuccessStateModel) onLoaded,
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