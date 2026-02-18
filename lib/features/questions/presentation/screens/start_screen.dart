import '../cubits/data_cubit.dart';
import '../states/start_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/base/data_state.dart';
import '../widgets/layouts/start_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../../../core/presentation/widgets/states/error_states/error_state.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import '../../../../core/presentation/widgets/states/error_states/no_internet_connection_state.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return CallRestLockIfNeeded(state: StartScreenState(),
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous, current) => current is StartScreenState,
                  builder: (context, state) {
                    final cubit = DataCubit.get(context);
                    final currentState = StartScreenState();
                    return state.map(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (data) =>
                          BuildStartScreen(
                            points: state.points,
                            hasMore: state.hasMore,
                            questions: state.questions,
                            currentIndex: state.currentIndex,
                            isConnected: connectivityProvider.isConnected,
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