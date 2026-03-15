import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import 'package:cash_money/core/presentation/states/app_state.dart';
import '../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:cash_money/features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/features/questions/presentation/states/base/data_state.dart';
import 'package:cash_money/features/questions/domain/useCases/questions_data_useCase.dart';
import 'package:cash_money/features/questions/data/repositories_impl/data_repository/firestore_data_repository.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FirestoreDataRepository();
    const currentState = DataState(appState: AppState());
    final questionsDataUseCase = QuestionsDataUseCase(repository: repository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectivityProvider>(
            create: (context) => ConnectivityProvider()),
        BlocProvider<DataCubit>(create: (context) =>
            DataCubit(questionsDataUseCase: questionsDataUseCase)..getData(currentState)
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (((LoginScreen()))),
      ),
    );
  }
}