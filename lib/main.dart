import 'package:cash_money/modules/login_screen/login_screen.dart';
import 'package:cash_money/shared/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:cash_money/shared/local/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'shared/firebase_options.dart';

void main() async{

  await CacheHelper.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // constructor
  // build
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (((LoginScreen()))),
    );
  }
}
