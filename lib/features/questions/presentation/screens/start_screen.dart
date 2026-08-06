import '../cubits/data_cubit.dart';
import 'package:flutter/material.dart';
import '../widgets/layouts/start_layout.dart';
import '../../../../core/presentation/states/loaded_states.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import 'package:cash_money/features/questions/presentation/screens/base/base_screen.dart';


class StartScreen extends BaseScreen {
  const StartScreen({super.key});

  static final cacheHelper = CacheHelper();
  static final connectivityService = ConnectivityService();

  @override
  QuestionsKeys get screenKey => QuestionsKeys.startScreen;

  @override
  Widget buildLoadedWidget({
    required DataCubit cubit,
    required VoidCallback loadMore,
    required SingleModelSuccessState data
  }) {

    return BuildStartScreen(
        getData: loadMore,
        cacheHelper: cacheHelper,
        questionsData: data.firstModel,
        connectivityService: connectivityService,
        onSave: (points) =>
            cubit.putPoints(points: points)
    );
  }

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends BaseScreenState<StartScreen> {}