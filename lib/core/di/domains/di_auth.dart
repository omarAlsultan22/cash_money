import '../../../features/auth/presentation/cubits/change_email_and_password_cubit.dart';
import '../../../features/auth/data/repositories_impl/firebase_sign_up_repository.dart';
import '../../../features/auth/domain/useCases/change_email_and_password_useCase.dart';
import '../../../features/auth/data/repositories_impl/firebase_auth_repository.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import '../../../features/auth/presentation/cubits/sign_in_cubit.dart';
import '../../../features/auth/presentation/cubits/sign_up_cubit.dart';
import '../../../features/auth/domain/useCases/sign_in_useCase.dart';
import '../../../features/auth/domain/useCases/sign_up_useCase.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import '../../data/data_sources/remote/firebase_auth.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class AuthDependencies {
  static void register() {
    // Repositories
    sl.registerLazySingleton(() =>
        FirebaseAuthRepository(auth: sl<FirebaseAuthService>()));
    sl.registerLazySingleton(() =>
        FirebaseSignUpRepository(repository: sl<FirestoreService>()));

    // UseCases
    sl.registerLazySingleton(() =>
        SignInUseCase(
            cacheHelper: sl<CacheHelper>(),
            authRepository: sl<FirebaseAuthRepository>()));

    sl.registerLazySingleton(() =>
        SignUpUseCase(
            cacheHelper: sl<CacheHelper>(),
            authRepository: sl<FirebaseAuthRepository>(),
            signUpRepository: sl<FirebaseSignUpRepository>()));

    sl.registerLazySingleton(() =>
        ChangeEmailAndPasswordUseCase(
            authRepository: sl<FirebaseAuthRepository>()));

    // Cubits
    sl.registerFactory(() =>
        SignInCubit(useCase: sl<SignInUseCase>(),
            connectivityService: sl<ConnectivityService>()));
    sl.registerFactory(() =>
        SignUpCubit(useCase: sl<SignUpUseCase>(),
            connectivityService: sl<ConnectivityService>()));
    sl.registerFactory(() =>
        ChangeEmailAndPasswordCubit(
            useCase: sl<ChangeEmailAndPasswordUseCase>(),
            connectivityService: sl<ConnectivityService>()));
  }
}