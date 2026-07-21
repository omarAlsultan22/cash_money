import '../states/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cash_money/core/constants/app_strings.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:cash_money/core/data/network/connectivity_service.dart';
import 'package:cash_money/features/auth/domain/useCases/change_email_and_password_useCase.dart';


class ChangeEmailAndPasswordCubit extends Cubit<AuthState> with ErrorHandlerMixin<AuthState> {
  final ChangeEmailAndPasswordUseCase _useCase;
  final ConnectivityService _connectivityService;

  ChangeEmailAndPasswordCubit({
    required ChangeEmailAndPasswordUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(AuthState.initial());

  static ChangeEmailAndPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    final isConnected = await _connectivityService.checkInternetConnection();
    if (!isConnected) {
      emit(
        AuthState(
          messageResult: MessageResult.error(
              error: NetworkAppException(error: AppStrings.noInternetMessage)),
        ),
      );
      return;
    }
    emit(AuthState(messageResult: MessageResult.loading()));
    try {
      _useCase.execute(
          newEmail: newEmail,
          newPassword: newPassword,
          currentPassword: currentPassword
      );
      emit(
          AuthState(messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              AuthState(messageResult: MessageResult.error(error: failure)
              )
      );
    }
  }
}