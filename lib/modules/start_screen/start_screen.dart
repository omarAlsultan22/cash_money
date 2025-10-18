import '../../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/start_layout.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppDataCubit, AppDataStates>(
        listener: (context, state) {
          statesListener(context, state);
        },
        builder: (context, state) =>
            BuildStartScreen(
                context: context,
                state: state
            )
    );
  }
}