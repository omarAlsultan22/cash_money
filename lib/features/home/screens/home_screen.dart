import '../../questions/data/repositories_impl/data_repository/firestore_data_repository.dart';
import '../../questions/data/repositories_impl/data_repository/hive_data_repository.dart';
import '../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../questions/data/repositories_impl/hybrid_data_repository.dart';
import '../../questions/domain/useCases/questions_data_useCase.dart';
import '../../questions/presentation/states/base/data_state.dart';
import '../../questions/presentation/cubits/data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../layouts/home_layout.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final firestoreRepository = FirestoreDataRepository();
    final hiveRepository = HiveDataRepository();

    final connectivityService = ConnectivityService();

    final hybridRepository = HybridDataRepository(
      remoteDatabase: firestoreRepository,
      localDatabase: hiveRepository,
      connectivityService: connectivityService,
    );

    final questionsDataUseCase = QuestionsDataUseCase(
      repository: hybridRepository
    );

    const state = DataState();

    return BlocProvider<DataCubit>(
      create: (context) =>
      DataCubit(
        questionsDataUseCase: questionsDataUseCase,
      )..getData(state),
      child: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          return const HomeLayout();
        },
      ),
    );
  }
}