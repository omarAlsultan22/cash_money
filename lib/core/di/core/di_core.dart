import '../service _locator.dart';
import '../../services/session_service.dart';
import '../../network/data/connectivity_service.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../../data/data_sources/local/cache_helper_service_impl.dart';
import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton(() => SessionService());
    sl.registerLazySingleton(() => AuthServiceImpl());
    sl.registerLazySingleton(() => CacheHelperImpl());
    sl.registerLazySingleton(() => PaginationHandler());
    sl.registerLazySingleton(() => ConnectivityService());
    sl.registerLazySingleton(() => FirestoreServiceImpl());
  }
}