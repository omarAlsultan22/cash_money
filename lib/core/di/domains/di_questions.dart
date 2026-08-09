import '../../../features/questions/data/repositories_impl/firestore_data_repository.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import '../../../features/questions/domain/useCases/questions_data_useCase.dart';
import '../../../features/questions/domain/useCases/points_useCase.dart';
import '../../../features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class QuestionsDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirestoreDataRepository(
            repository: sl<FirestoreService>()));

    // UseCase
    sl.registerLazySingleton(() =>
        PointsUseCase(repository: sl<FirestoreDataRepository>()));
    sl.registerLazySingleton(() =>
        QuestionsDataUseCase(repository: sl<FirestoreDataRepository>()));

    // Cubit
    sl.registerFactory(() =>
        DataCubit(
            cacheHelper: sl<CacheHelper>(),
            pointsUseCase: sl<PointsUseCase>(),
            connectivityService: sl<ConnectivityService>(),
            questionsDataUseCase: sl<QuestionsDataUseCase>()));
  }
}