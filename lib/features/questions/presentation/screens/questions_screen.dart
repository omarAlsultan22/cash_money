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


class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
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
              state: QuestionsScreenState(appState: const AppState()),
              child: BlocBuilder<DataCubit, DataState>(
                  buildWhen: (previous,
                      current) => current is QuestionsScreenState,
                  builder: (context, state) {
                    final state = QuestionsScreenState(
                        appState: const AppState());
                    return state.map(
                      onInitial: () => const InitialStateWidget(),
                      onLoading: () => const LoadingStateWidget(),
                      onLoaded: (data) =>
                          BuildQuestionsScreen(
                            hasMore: state.hasMore,
                            questions: state.questions,
                            getData: () => _cubit.getData(state),
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
