import 'firebase_options.dart';
import '../di/service _locator.dart';
import '../services/session_service.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/data_sources/local/cache_helper.dart';
import 'package:cash_money/core/errors/exceptions/components_exception.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late final CacheHelper _cacheHelper;
  late final SessionService _sessionService;

  bool _isInitialized = false;

  Future<void> _initializeServices() async {
    await Future.wait([
      _cacheHelper.init(),
      _sessionService.loadFromStorage(),
      Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
      )
    ]);
  }

  Future<void> init() async {
    if (_isInitialized) return;

    _cacheHelper = sl<CacheHelper>();
    _sessionService = sl<SessionService>();

    try {
      await _initializeServices();
    }
    catch(e) {
      throw ComponentsException(error: e);
    }

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await Future.wait<void>([
      _cacheHelper.init(),
      Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform)
    ]);
  }
}