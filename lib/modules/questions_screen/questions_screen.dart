import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/questions_layout.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppDataCubit()
        ..getQuestionsData(),
      child: BlocConsumer<AppDataCubit, AppDataStates>(
          listener: (context, state) {
            if (state is AppDataErrorState && state.key == Screens.start) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.red[800],
                ),
              );
            }
          },
          builder: (context, state) =>
              BuildQuestionsScreen(
                  context: context,
                  state: state,
              )
      ),
    );
  }
}