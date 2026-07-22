import '../cubits/data_cubit.dart';
import '../states/data_state.dart';
import 'package:flutter/material.dart';
import '../widgets/layouts/start_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cash_money/core/presentation/states/loaded_states.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';


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
    _cubit.getData(_startScreen);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentScreen(DataState current) {
      return current.key == _startScreen;
    }

    return BlocBuilder<DataCubit, DataState>(
        buildWhen: (previous, current) => isCurrentScreen(current),
        builder: (context, state) {
          final cacheHelper = CacheHelper();
          final cubit = DataCubit.get(context);
          return state.when(
            onInitial: () =>
            const InitialStateWidget(text: 'Data', icon: Icons.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              if (loadedState is DoubleModelSuccessState) {
                return BuildStartScreen(
                    cacheHelper: cacheHelper,
                    questionsData: loadedState.firstModel,
                    gameState: loadedState.secondModel,
                    getData: () => cubit.loadMoreData(),
                    onSave: (points) =>
                        cubit.putPoints(points: points)
                );
              }
              return const InitialStateWidget(
                  text: 'Data', icon: Icons.menu);
            },
            onError: (error) =>
                error.buildErrorWidget(
                    onRetry: () => cubit.loadMoreData()
                ),
          );
        }
    );
  }
}