import '../../../../core/data/models/user_model.dart';
import '../../../../core/presentation/states/app_state.dart';
import '../../../../core/presentation/states/base/when_states.dart';
import 'package:cash_money/core/errors/exceptions/app_exception.dart';


class SettingsState implements WhenStates {
  final UserModel? userModel;
  final AppState? appState;

  SettingsState({this.userModel, this.appState});

  String get userName => userModel!.userName;

  String get userPhone => userModel!.userPhone;

  String get userLocation => userModel!.userLocation;

  bool get _isLoading => appState!.isLoading;

  AppException? get _failure => appState!.failure;

  SettingsState updateState({
    UserModel? userModel,
    AppState? appState
  }) {
    return SettingsState(
        userModel: userModel ?? this.userModel,
        appState: appState ?? this.appState
    );
  }


  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException error) onError}) {
    if (_failure != null) {
      return onError(_failure!);
    }

    if (_isLoading) {
      return onLoading();
    }

    if (!_isLoading && userModel != null) {
      return onLoaded();
    }

    return onInitial();
  }
}