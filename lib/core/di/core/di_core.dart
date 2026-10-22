import '../service _locator.dart';
import '../../services/session_service.dart';
import '../../domain/data_sources/auth_service.dart';
import '../../domain/data_sources/cache_helper.dart';
import '../../network/data/connectivity_service.dart';
import '../../domain/data_sources/firestore_service.dart';
import '../../network/domain/i_connectivity_service.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../../../features/questions/presentation/utils/helpers/pagination_state_manager.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    sl.registerLazySingleton<CacheHelper>(() => CacheHelperImpl());
    sl.registerLazySingleton<SessionService>(() => SessionService());
    sl.registerLazySingleton<PaginationHandler>(() => PaginationHandler());
    sl.registerLazySingleton<FirestoreService>(() => FirestoreServiceImpl());
    sl.registerLazySingleton<IConnectivityService>(() => ConnectivityService());
  }
}