import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'core/config/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/data/data_sources/local/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cash_money/core/config/bloc_observer.dart';
import 'core/data/data_sources/local/shared_preferences.dart';


void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await CacheHelper.init();
    await HiveOperations.init();
    Bloc.observer = MyBlocObserver();
  }
  catch (error) {
    rethrow;
  }

  runApp(const MyApp());
}

