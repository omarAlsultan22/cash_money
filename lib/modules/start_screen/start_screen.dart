import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/start_layout.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppDataCubit()
        ..getStartData(),
      child: BlocConsumer<AppDataCubit, AppDataStates>(
          listener: (context, state) {
            if (state is AppDataErrorState) {
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
              BuildStartScreen(
                  context: context,
                  state: state
              )
      ),
    );
  }
}