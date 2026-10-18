import '../service _locator.dart';
import '../../services/session_service.dart';
import '../../services/connectivity_service.dart';
import '../../data/data_sources/local/cache_helper_service_impl.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton(() => CacheHelperServiceImpl());
    sl.registerLazySingleton(() => SessionService());
    sl.registerLazySingleton(() => FirestoreServiceImpl());
    sl.registerLazySingleton(() => PaginationHandler());
    sl.registerLazySingleton(() => AuthServiceImpl());
    sl.registerLazySingleton(() => ConnectivityService());
  }
}