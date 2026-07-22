import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import 'package:cash_money/core/presentation/states/loaded_states.dart';
import '../widgets/layouts/questions_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _cubit.getData(_questionsScreen);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentScreen(DataState current) {
      return current.key == _questionsScreen;
    }

    return BlocBuilder<DataCubit, DataState>(
        buildWhen: (previous, current) => isCurrentScreen(current),
        builder: (context, state) {
          return state.when(
            onInitial: () =>
            const InitialStateWidget(text: 'Data', icon: Icons.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (loadedState) {
              if (loadedState is DoubleModelSuccessState) {
                return BuildQuestionsScreen(
                  isLoading: false,
                  questionsData: loadedState.firstModel,
                  getData: () => _cubit.loadMoreData(),
                );
              }
              return const InitialStateWidget(text: 'Data', icon: Icons.menu);
            },
            onError: (error) =>
                error.buildErrorWidget(
                    onRetry: () => _cubit.loadMoreData()
                ),
          );
        }
    );
  }
}
