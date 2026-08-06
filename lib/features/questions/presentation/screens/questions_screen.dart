import 'package:cash_money/features/questions/presentation/enums/questions_keys.dart';
import 'package:cash_money/features/questions/presentation/cubits/data_cubit.dart';
import 'package:cash_money/core/presentation/states/loaded_states.dart';
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
    required SingleModelSuccessState data
  }) =>
      BuildQuestionsScreen(
          isLoading: false,
          loadMoreData: loadMoreData,
          questionsData: data.firstModel
      );

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends BaseScreenState<QuestionsScreen> {}
