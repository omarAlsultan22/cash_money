import 'package:cash_money/core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../questions/data/repositories_impl/data_repository/firestore_data_repository.dart';
import '../../questions/data/repositories_impl/data_repository/hive_data_repository.dart';
import '../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../questions/data/repositories_impl/hybrid_data_repository.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import '../../questions/domain/useCases/questions_data_useCase.dart';
import 'package:cash_money/core/data/data_sources/local/hive.dart';
import '../../questions/presentation/states/data_state.dart';
import '../../questions/presentation/cubits/data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../layouts/home_layout.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final hiveService = HiveService();
    final firestoreService = FirestoreService();
    final firestoreRepository = FirestoreDataRepository(repository: firestoreService);
    final hiveRepository = HiveDataRepository(repository: hiveService);

    final connectivityService = ConnectivityService();

    final hybridRepository = HybridDataRepository(
      remoteDatabase: firestoreRepository,
      localDatabase: hiveRepository,
      connectivityService: connectivityService,
    );

    final questionsDataUseCase = QuestionsDataUseCase(
        repository: hybridRepository
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