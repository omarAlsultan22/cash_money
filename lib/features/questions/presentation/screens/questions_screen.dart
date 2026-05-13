import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../../../core/presentation/widgets/states/error_state.dart';
import '../widgets/connectivity_aware_screen.dart';
import '../widgets/layouts/questions_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../states/data_state.dart';
import '../cubits/data_cubit.dart';


class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late DataCubit _cubit;

  static const _questionsScreen = QuestionsKeys.questionsScreen;

  @override
  void initState() {
    super.initState();
    _cubitInitialization();
  }

  void _cubitInitialization() {
    _cubit = DataCubit.get(context);
    _cubit
      ..getData(_questionsScreen)
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
      return current.key == _questionsScreen;
    }

    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, childWidget) {
          return ConnectivityAwareScreen(
              isConnected: connectivityProvider.isConnected,
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous, current) => isErrorState(current),
                  builder: (context, state) {
                    return state.when(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (loadedState) =>
                          BuildQuestionsScreen(
                              isLoading: false,
                              questionsData: loadedState.firstModel,
                              getData: () => _cubit.loadMoreData(),
                              isConnected: connectivityProvider.isConnected
                          ),
                      onError: (error) =>
                          error.buildErrorWidget(
                              onRetry: () => _cubit.loadMoreData()
                          ),
                    );
                  }
              )
          );
        }
    );
  }
}
