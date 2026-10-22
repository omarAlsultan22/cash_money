import '../../../features/settings/data/repositories_impl/settings_repository_impl.dart';
import 'package:cash_money/features/settings/presentation/cubits/settings_cubit.dart';
import '../../../features/settings/domain/repositories/settings_repository.dart';
import '../../../features/settings/domain/use_cases/settings_use_case.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../../domain/data_sources/firestore_service.dart';
import '../../network/domain/i_connectivity_service.dart';
import '../service _locator.dart';


class SettingsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<SettingsRepository>(() =>
        SettingsRepositoryImpl(
            dataSource: sl<FirestoreService>(),
            sessionService: sl<SessionService>()
        )
    );

    // UseCase
    sl.registerLazySingleton<SettingsUseCase>(() =>
        SettingsUseCase(
            repository: sl<SettingsRepository>()));

    // Cubit
    sl.registerFactory<SettingsCubit>(() =>
        SettingsCubit(
            settingsUseCase: sl<SettingsUseCase>(),
            connectivityService: sl<IConnectivityService>()));
  }
}