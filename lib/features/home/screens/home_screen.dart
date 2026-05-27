import 'package:cash_money/core/presentation/providers/connectivity_provider.dart';
import '../../questions/data/repositories_impl/data_repository/firestore_data_repository.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import '../../questions/domain/useCases/questions_data_useCase.dart';
import '../../questions/presentation/states/data_state.dart';
import '../../questions/presentation/cubits/data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/layouts/home_layout.dart';
import 'package:flutter/cupertino.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final firestoreService = FirestoreService();
    final firestoreRepository = FirestoreDataRepository(repository: firestoreService);
    final questionsDataUseCase = QuestionsDataUseCase(
        repository: firestoreRepository
    );

    final connectivityProvider = ConnectivityProvider();

    return BlocProvider<DataCubit>(
      create: (context) =>
          DataCubit(
              questionsDataUseCase: questionsDataUseCase,
              connectivityProvider: connectivityProvider
          ),
      child: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          return const HomeLayout();
        },
      ),
    );
  }
}