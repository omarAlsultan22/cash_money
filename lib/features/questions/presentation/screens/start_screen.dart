import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';

import '../cubits/data_cubit.dart';
import '../states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/start_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/error_state.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';


class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late DataCubit _cubit;

  static const _startScreen = QuestionsKeys.startScreen;

  @override
  void initState() {
    super.initState();
    _cubitInitialization();
  }

  void _cubitInitialization() {
    _cubit = DataCubit.get(context);
    _cubit
      ..getData(_startScreen)
      ..startMonitoring();
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    bool isErrorState(DataState current) {
      return current.key == _startScreen;
    }

    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareScreen(
              isConnected: connectivityProvider.isConnected,
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous, current) => isErrorState(current),
                  builder: (context, state) {
                    final cacheHelper = CacheHelper();
                    final cubit = DataCubit.get(context);
                    return state.when(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (loadedState) =>
                          BuildStartScreen(
                            cacheHelper: cacheHelper,
                            questionsData: loadedState.firstModel,
                            gameState: loadedState.secondModel,
                            getData: () => cubit.loadMoreData(),
                            isConnected: connectivityProvider.isConnected,
                          ),
                      onError: (error) =>
                          ErrorStateWidget(error: error.message,
                              onRetry: () => cubit.loadMoreData()),
                    );
                  }
              )
          );
        }
    );
  }
}