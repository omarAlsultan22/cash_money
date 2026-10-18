import '../../../features/settings/data/repositories_impl/settings_repository_impl.dart';
import 'package:cash_money/features/settings/presentation/cubits/settings_cubit.dart';
import '../../../features/settings/domain/use_cases/settings_use_case.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../service _locator.dart';


class SettingsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        SettingsRepositoryImpl(
            dataSource: sl<FirestoreServiceImpl>(),
            sessionService: sl<SessionService>()
        )
    );

    // UseCase
    sl.registerLazySingleton(() =>
        SettingsUseCase(
            repository: sl<SettingsRepositoryImpl>()));

    // Cubit
    sl.registerFactory(() =>
        SettingsCubit(
            settingsUseCase: sl<SettingsUseCase>(),
            connectivityService: sl<ConnectivityService>()));
  }
}