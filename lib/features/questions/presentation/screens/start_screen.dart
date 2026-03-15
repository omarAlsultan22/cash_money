import '../cubits/data_cubit.dart';
import '../states/start_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/base/data_state.dart';
import '../widgets/layouts/start_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/connectivity_aware_screen.dart';
import '../../../../core/presentation/states/app_state.dart';
import '../../../../core/presentation/widgets/states/error_state.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCurrentState(DataState current) {
      return current.runtimeType == DataState ||
          current is StartScreenState;
    }

    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareScreen(
              isConnected: connectivityProvider.isConnected,
              state: StartScreenState(appState: const AppState()),
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous, current) => isCurrentState(current),
                  builder: (context, state) {
                    final cubit = DataCubit.get(context);
                    final currentState = StartScreenState(
                        appState: const AppState());
                    return state.map(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (data) =>
                          BuildStartScreen(
                            points: state.points,
                            hasMore: state.hasMore,
                            questions: state.questions,
                            currentIndex: state.currentIndex,
                            getData: () => cubit.getData(currentState),
                            isConnected: connectivityProvider.isConnected,
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