import 'package:cash_money/features/settings/domain/useCases/settings_useCase.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import 'package:cash_money/core/data/network/connectivity_service.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../data/repositories_impl/firestore_settings_repository.dart';
import 'package:cash_money/core/presentation/states/loaded_states.dart';
import '../widgets/layouts/settings_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/settings_state.dart';
import '../cubits/settings_cubit.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = FirestoreService();
    final cacheHelper = CacheHelper();
    final settingsRepository = FirebaseSignUpRepository(
        repository: repository,
        cacheHelper: cacheHelper);
    final settingsUseCase = SettingsUseCase(
        repository: settingsRepository);
    final connectivityService = ConnectivityService();
    return BlocProvider<SettingsCubit>(
        create: (context) =>
        SettingsCubit(
            settingsUseCase: settingsUseCase,
            connectivityService: connectivityService)
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
                onLoaded: (loadedState) {
                  if (loadedState is DoubleModelSuccessState) {
                    SettingsLayout(
                      userModel: loadedState.firstModel,
                      messageResult: loadedState.secondModel,
                      onUpdate: (userModel) =>
                          cubit.updateInfo(
                            userName: userModel.userName,
                          ),
                    );
                  }
                  return const InitialStateWidget(
                      text: 'Info', icon: Icons.info_outline);
                },
                onError: (error) =>
                    error.buildErrorWidget(
                        onRetry: () => cubit.getInfo()
                    ),
              );
            }
        )
    );
  }
}