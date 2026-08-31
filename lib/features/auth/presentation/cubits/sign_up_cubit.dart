import '../states/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/connectivity_service.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:cash_money/core/errors/exceptions/network_app_exception.dart';
import 'package:cash_money/features/auth/domain/useCases/sign_up_useCase.dart';


class SignUpCubit extends Cubit<AuthState> with ErrorHandlerMixin<AuthState> {
  final SignUpUseCase _useCase;
  final ConnectivityService _connectivityService;

  SignUpCubit({
    required SignUpUseCase useCase,
    required ConnectivityService connectivityService,
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(AuthState.initial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  Future<void> signUp({
    required String userName,
    required String userEmail,
    required String userPassword,
  }) async {
    final isConnected = await _connectivityService.checkInternetConnection();
    if (!isConnected) {
      throw NetworkAppException();
    }

    emit(AuthState(messageResult: MessageResult.loading()));
    try {
      await _useCase.execute(
        userName: userName,
        userEmail: userEmail,
        userPassword: userPassword,
      );
      emit(AuthState(
          messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              AuthState(
                  messageResult: MessageResult.error(
                    error: failure,
                  )
              )
      );
    }
  }
}