import '../../cubits/data_cubit.dart';
import '../../states/data_state.dart';
import 'package:flutter/material.dart';
import '../../enums/questions_keys.dart';
import '../../mixins/listener_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/states/loaded_states.dart';
import 'package:cash_money/core/presentation/widgets/app_bar_widget.dart';
import '../../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../../core/presentation/widgets/states/loading_state.dart';


/// Base screen for all question-related screens.
/// Provides common state management and lifecycle handling.
abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  QuestionsKeys get screenKey;

  Widget buildLoadedWidget({
    required DataCubit cubit,
    required VoidCallback loadMoreData,
    required SingleModelSuccessState data
  });
}

abstract class BaseScreenState<T extends BaseScreen>
    extends State<T> with ListenerMixin {

  late DataCubit cubit;

  @override
  @mustCallSuper
  Future<void> initState() async {
    super.initState();
    initializeListener(widget.screenKey);
    await _cubitInitialization();
  }

  Future<void> _cubitInitialization() async {
    cubit = DataCubit.get(context);
    await cubit.getData(widget.screenKey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
        buildWhen: (previous, current) => handleListener(current.key),
        builder: (context, state) {
          return state.when(
            onInitial: () =>
            const InitialStateWidget(text: 'Data', icon: Icons.menu),
            onLoading: () => const LoadingStateWidget(),
            onLoaded: (data) {
              return widget.buildLoadedWidget(
                  data: data,
                  cubit: cubit,
                  loadMoreData: () async => await cubit.loadMoreData()
              );
            },
            onError: (error) =>
                error.buildErrorWidget(
                    appBar: AppBarWidget.build(),
                    onRetry: () async => await cubit.loadMoreData()
                ),
          );
        }
    );
  }
}