import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';
import '../../../features/questions/data/repositories_impl/app_data_repository_impl.dart';
import '../../../features/questions/domain/use_cases/questions_data_use_case.dart';
import '../../../features/questions/domain/repositories/app_data_repository.dart';
import '../../../features/questions/domain/use_cases/points_use_case.dart';
import '../../../features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/core/services/session_service.dart';
import '../../domain/data_sources/firestore_service.dart';
import '../../network/domain/i_connectivity_service.dart';
import '../../domain/data_sources/cache_helper.dart';
import '../service _locator.dart';


class QuestionsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<AppDataRepository>(() =>
        AppDataRepositoryImpl(
            dataSource: sl<FirestoreService>(),
            sessionService: sl<SessionService>()));

    // UseCases
    sl.registerLazySingleton<PointsUseCase>(() =>
        PointsUseCase(repository: sl<AppDataRepository>()));

    sl.registerLazySingleton<QuestionsDataUseCase>(() =>
        QuestionsDataUseCase(
            repository: sl<AppDataRepository>(),
            paginationHandler: sl<PaginationHandler>()));

    // Cubit
    sl.registerFactory<DataCubit>(() =>
        DataCubit(
            cacheHelper: sl<CacheHelper>(),
            pointsUseCase: sl<PointsUseCase>(),
            connectivityService: sl<IConnectivityService>(),
            questionsDataUseCase: sl<QuestionsDataUseCase>()));
  }
}