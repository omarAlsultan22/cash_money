import '../../../../core/presentation/widgets/states/error_states/no_internet_connection_state.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/widgets/states/error_states/error_state.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../widgets/connectivity_aware_screen.dart';
import '../widgets/layouts/questions_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/base/data_state.dart';
import '../states/questions_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../cubits/data_cubit.dart';


class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return CallRestLockIfNeeded(state: QuestionsScreenState(),
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous,
                      current) => current is QuestionsScreenState,
                  builder: (context, state) {
                    final cubit = DataCubit.get(context);
                    final currentState = QuestionsScreenState();
                    return state.map(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (data) =>
                          BuildQuestionsScreen(
                              hasMore: state.hasMore,
                              questions: state.questions,
                              isConnected: connectivityProvider.isConnected
                          ),
                      onError: (error) =>
                      error.isConnectionError
                          ? ConnectionErrorStateWidget(error: error.message,
                          onRetry: () => cubit.getData(currentState))
                          : ErrorStateWidget(error: error.message,
                          onRetry: () => cubit.getData(currentState)),
                    );
                  }
              )
          );
        }
    );
  }
}