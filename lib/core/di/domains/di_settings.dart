import '../../../features/settings/data/repositories_impl/firestore_settings_repository.dart';
import 'package:cash_money/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import '../../../features/settings/domain/useCases/settings_useCase.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class SettingsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirebaseSettingsRepository(
            repository: sl<FirestoreService>(),
            cacheHelper: sl<CacheHelper>()));

    // UseCase
    sl.registerLazySingleton(() =>
        SettingsUseCase(
            repository: sl<FirebaseSettingsRepository>()));

    // Cubit
    sl.registerFactory(() =>
        SettingsCubit(
            settingsUseCase: sl<SettingsUseCase>(),
            connectivityService: sl<ConnectivityService>()));
  }
}