import '../../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/questions_layout.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';


class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppDataCubit, AppDataStates>(
        listener: (context, state) {
          statesListener(context, state);
        },
        builder: (context, state) =>
            BuildQuestionsScreen(
              context: context,
              state: state,
            )
    );
  }
}