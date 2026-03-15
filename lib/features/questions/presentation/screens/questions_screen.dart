import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../../../core/presentation/widgets/states/error_state.dart';
import 'package:cash_money/core/presentation/states/app_state.dart';
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
    bool isCurrentState(DataState current) {
      return current.runtimeType == DataState ||
          current is QuestionsScreenState;
    }

    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareScreen(
              isConnected: connectivityProvider.isConnected,
              state: QuestionsScreenState(appState: const AppState()),
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous, current) => isCurrentState(current),
                  builder: (context, state) {
                    final cubit = DataCubit.get(context);
                    final currentState = QuestionsScreenState(
                        appState: const AppState());
                    return state.map(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (data) =>
                          BuildQuestionsScreen(
                              isLoading: true,
                              hasMore: state.hasMore,
                              questions: state.questions,
                              getData: () => cubit.getData(currentState),
                              isConnected: connectivityProvider.isConnected
                          ),
                      onError: (error) =>
                          ErrorStateWidget(error: error.message,
                              onRetry: () => cubit.getData(currentState)),
                    );
                  }
              )
          );
        }
    );
  }
}