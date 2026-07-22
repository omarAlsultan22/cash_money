import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'core/errors/mappers/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/core/config/bloc_observer.dart';
import 'core/data/data_sources/local/shared_preferences.dart';


void main() async {
  final cacheHelper = CacheHelper();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED
    );
    await cacheHelper.init();
    Bloc.observer = MyBlocObserver();
    runApp(const MyApp());
  }
  catch (e, stackTrace) {
    final errorHandler = ErrorHandler(
      error: e,
      stackTrace: stackTrace,
    );
    final exception = errorHandler.handleException();
    runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: exception.buildErrorWidget(
              onRetry: () => runApp(const MyApp())
          ),
        )
    );
  }
}

