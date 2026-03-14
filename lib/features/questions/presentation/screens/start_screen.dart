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


class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late DataCubit _cubit;

  @override
  void initState() {
    super.initState();
    _initCubit();
  }

  void _initCubit() {
    _cubit = DataCubit.get(context)
      ..initializeIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareScreen(
              isConnected: connectivityProvider.isConnected,
              state: StartScreenState(appState: const AppState()),
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous, current) => current is StartScreenState,
                  builder: (context, state) {
                    final state = StartScreenState(
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
                            getData: ()=> _cubit.getData(state),
                            isConnected: connectivityProvider.isConnected,
                          ),
                      onError: (error) =>
                          ErrorStateWidget(error: error.message,
                              onRetry: () => _cubit.getData(state)),
                    );
                  }
              )
          );
        }
    );
  }
}