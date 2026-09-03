import 'package:cash_money/features/questions/data/models/data_success_state_model.dart';
import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import 'package:cash_money/features/questions/presentation/cubits/data_cubit.dart';
import '../widgets/layouts/questions_layout.dart';
import 'package:flutter/material.dart';
import 'base/base_screen.dart';


class QuestionsScreen extends BaseScreen {
  const QuestionsScreen({super.key});

  @override
  QuestionsKeys get screenKey => QuestionsKeys.questionsScreen;

  @override
  Widget buildLoadedWidget({
    required DataCubit cubit,
    required VoidCallback loadMoreData,
    required DataSuccessStateModel data
  }) =>
      BuildQuestionsScreen(
          isLoading: false,
          loadMoreData: loadMoreData,
          questionsData: data.questionsData
      );

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends BaseScreenState<QuestionsScreen> {}
