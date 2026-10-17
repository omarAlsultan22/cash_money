import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';
import '../../../features/questions/data/repositories_impl/app_data_repository_impl.dart';
import '../../../features/questions/domain/use_cases/questions_data_use_case.dart';
import 'package:cash_money/core/data/data_sources/local/cache_helper.dart';
import '../../../features/questions/domain/use_cases/points_use_case.dart';
import '../../../features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class QuestionsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        AppDataRepositoryImpl(
            repository: sl<FirestoreService>(),
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
            cacheHelper: sl<CacheHelper>(),
            pointsUseCase: sl<PointsUseCase>(),
            connectivityService: sl<ConnectivityService>(),
            questionsDataUseCase: sl<QuestionsDataUseCase>()));
  }
}