import 'base/main_app_sub_state.dart';
import '../../errors/exceptions/base/app_exception.dart';


class InitialState extends MainAppSubState{
  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError,
  }) {
    return onInitial();
  }
}


class LoadingState extends MainAppSubState{
  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError,
  }) {
    return onLoading();
  }
}


class SuccessState extends MainAppSubState {
  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError,
  }) {
    return onLoaded();
  }
}


class ErrorState extends MainAppSubState {
  final AppException failure;

  ErrorState({
    required this.failure,
  });

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError
  }) {
    return onError(failure);
  }
}