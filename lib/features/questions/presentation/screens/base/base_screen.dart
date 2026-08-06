import '../../cubits/data_cubit.dart';
import '../../states/data_state.dart';
import 'package:flutter/material.dart';
import '../../enums/questions_keys.dart';
import '../../mixins/listener_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/states/loaded_states.dart';
import '../../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../../core/presentation/widgets/states/loading_state.dart';


/// Base screen for all question-related screens.
/// Provides common state management and lifecycle handling.
abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  QuestionsKeys get screenKey;

  Widget buildLoadedWidget({
    required DataCubit cubit,
    required VoidCallback loadMore,
    required SingleModelSuccessState data
  });
}

abstract class BaseScreenState<T extends BaseScreen>
    extends State<T> with ListenerMixin {

  late DataCubit cubit;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    initializeListener(widget.screenKey);
    _cubitInitialization();
  }

  void _cubitInitialization() {
    cubit = DataCubit.get(context);
    cubit.getData(widget.screenKey);
  }

  @override
  @mustCallSuper
  void dispose() {
    cubit.close();
    super.dispose();
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
                  loadMore: cubit.loadMoreData
              );
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