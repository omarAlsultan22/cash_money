import 'firebase_options.dart';
import '../di/service _locator.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/data_sources/local/shared_preferences.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late final CacheHelper cacheHelper;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    cacheHelper = sl<CacheHelper>();

    await Future.wait([
      cacheHelper.init(),
      Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform)
    ]);

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await Future.wait<void>([
      cacheHelper.init(),
      Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform)
    ]);
  }
}