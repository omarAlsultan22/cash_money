import '../service _locator.dart';
import '../../services/connectivity_service.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../../data/data_sources/remote/firebase_auth.dart';
import '../../data/data_sources/local/shared_preferences.dart';
import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton(() => CacheHelper());
    sl.registerLazySingleton(() => FirestoreService());
    sl.registerLazySingleton(() => PaginationHandler());
    sl.registerLazySingleton(() => FirebaseAuthService());
    sl.registerLazySingleton(() => ConnectivityService());
  }
}