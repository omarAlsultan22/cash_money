import '../cubits/data_cubit.dart';
import 'package:flutter/material.dart';
import '../widgets/layouts/start_layout.dart';
import '../../../../core/di/service _locator.dart';
import '../../data/models/data_success_state.dart';
import 'package:cash_money/core/services/connectivity_service.dart';
import 'package:cash_money/core/data/data_sources/local/cache_helper.dart';
import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import 'package:cash_money/features/questions/presentation/screens/base/base_screen.dart';


class StartScreen extends BaseScreen {
  const StartScreen({super.key});

  static final cacheHelper = sl<CacheHelper>();
  static final connectivityService = sl<ConnectivityService>();

  @override
  QuestionsKeys get screenKey => QuestionsKeys.startScreen;

  @override
  Widget buildLoadedWidget({
    required DataCubit cubit,
    required VoidCallback loadMoreData,
    required DataSuccessState data
  }) {
    return BuildStartScreen(
        cacheHelper: cacheHelper,
        loadMoreData: loadMoreData,
        questionsData: data.questionsData,
        connectivityService: connectivityService,
        onSave: (points) async =>
            await cubit.putPoints(points: points)
    );
  }

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends BaseScreenState<StartScreen> {}