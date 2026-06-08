import '../states/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:cash_money/core/data/models/message_result.dart';
import '../../../../core/data/network/connectivity_service.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:cash_money/features/auth/domain/useCases/sign_in_useCase.dart';


class SignInCubit extends Cubit<AuthState> with ErrorHandlerMixin<AuthState> {
  final SignInUseCase _useCase;
  final ConnectivityService _connectivityService;

  SignInCubit({
    required SignInUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(AuthState.initial());

  static SignInCubit get(context) => BlocProvider.of(context);

  Future<void> signIn({
    required String userEmail,
    required String userPassword,
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
      if (userEmail.isEmpty || userPassword.isEmpty) {
        throw('Fields cannot be empty.');
      }
      _useCase.signInExecute(
          userEmail: userEmail,
          userPassword: userPassword
      );
      emit(AuthState(
          messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              AuthState(messageResult: MessageResult.error(error: failure)
              )
      );
    }
  }
}