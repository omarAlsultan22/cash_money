import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/services/connectivity_service.dart';
import '../core/data/data_sources/local/shared_preferences.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/questions/domain/useCases/points_useCase.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import 'package:cash_money/features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/features/questions/domain/useCases/questions_data_useCase.dart';
import 'package:cash_money/features/questions/data/repositories_impl/firestore_data_repository.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheHelper = CacheHelper();
    final firestoreService = FirestoreService();
    final firestoreDataRepository = FirestoreDataRepository(
        repository: firestoreService);
    final pointsUseCase = PointsUseCase(repository: firestoreDataRepository);
    final questionsDataUseCase = QuestionsDataUseCase(
        repository: firestoreDataRepository
    );
    final connectivityService = ConnectivityService();

    return BlocProvider<DataCubit>(create: (context) =>
        DataCubit(
          cacheHelper: cacheHelper,
          pointsUseCase: pointsUseCase,
          connectivityService: connectivityService,
          questionsDataUseCase: questionsDataUseCase,
        ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
      ),
    );
  }
}