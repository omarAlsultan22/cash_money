import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/home_screen.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppDataCubit()
        ..getInfo(),
      child: BlocBuilder<AppDataCubit, AppDataStates>(
        builder: (context, state) {
          return buildHomeScreen(context);
        },
      ),
    );
  }
}