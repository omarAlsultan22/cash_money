import '../service _locator.dart';
import '../../services/session_service.dart';
import '../../domain/data_sources/auth_service.dart';
import '../../domain/data_sources/cache_helper.dart';
import '../../network/data/connectivity_service.dart';
import '../../domain/data_sources/firestore_service.dart';
import '../../network/domain/i_connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../data/data_sources/remote/auth_service_impl.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../../../features/questions/domain/use_cases/pagination_state_manager.dart';


class CoreDependencies {
  static void register() {
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    sl.registerLazySingleton<PaginationHandler>(() => PaginationHandler());
    sl.registerLazySingleton<FirestoreService>(() => FirestoreServiceImpl());
    sl.registerLazySingleton<IConnectivityService>(() => ConnectivityService());
    sl.registerLazySingleton<CacheHelper>(() =>
        CacheHelperImpl(prefs: sl<SharedPreferences>()
        )
    );
    sl.registerLazySingleton<SessionService>(() =>
        SessionService(cacheHelper: sl<CacheHelper>()
        )
    );
  }
}