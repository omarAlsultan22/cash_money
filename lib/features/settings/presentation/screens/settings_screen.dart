import 'package:cash_money/core/presentation/widgets/app_bar_widget.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../../../core/di/service _locator.dart';
import '../widgets/layouts/settings_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/settings_state.dart';
import '../cubits/settings_cubit.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
        create: (context) =>
        sl<SettingsCubit>()
          ..getInfo(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final cubit = SettingsCubit.get(context);
              return state.when(
                onInitial: () =>
                const InitialStateWidget(
                    text: 'Info', icon: Icons.info_outline),
                onLoading: () =>
                const LoadingStateWidget(),
                onLoaded: (data) {
                  return SettingsLayout(
                    userModel: data.userModel,
                    messageResult: data.messageResult,
                    onUpdate: (userModel) async =>
                    await cubit.updateInfo(
                      userName: userModel.userName ?? '',
                    ),
                  );
                },
                onError: (error) =>
                    error.buildErrorWidget(
                      appBar: AppBarWidget.build(),
                      onRetry: () => cubit.getInfo(),
                    ),
              );
            }
        )
    );
  }
}