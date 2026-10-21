import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';
import '../../../features/questions/data/repositories_impl/app_data_repository_impl.dart';
import '../../../features/questions/domain/use_cases/questions_data_use_case.dart';
import 'package:cash_money/core/data/data_sources/local/cache_helper_impl.dart';
import '../../../features/questions/domain/use_cases/points_use_case.dart';
import '../../../features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/core/network/data/connectivity_service.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../service _locator.dart';


class QuestionsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        AppDataRepositoryImpl(
            dataSource: sl<FirestoreServiceImpl>(),
            sessionService: sl<SessionService>()));

    // UseCases
    sl.registerLazySingleton(() =>
        PointsUseCase(repository: sl<AppDataRepositoryImpl>()));

    sl.registerLazySingleton(() =>
        QuestionsDataUseCase(
            repository: sl<AppDataRepositoryImpl>(),
            paginationHandler: sl<PaginationHandler>()));

    // Cubit
    sl.registerFactory(() =>
        DataCubit(
            cacheHelper: sl<CacheHelperImpl>(),
            pointsUseCase: sl<PointsUseCase>(),
            connectivityService: sl<ConnectivityService>(),
            questionsDataUseCase: sl<QuestionsDataUseCase>()));
  }
}