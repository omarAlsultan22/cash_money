import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:cash_money/features/settings/domain/useCases/settings_useCase.dart';
import 'package:cash_money/core/data/data_sources/remote/firestore.dart';
import 'package:cash_money/core/data/data_sources/local/shared_preferences.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../../../core/presentation/widgets/states/error_state.dart';
import '../../data/repositories_impl/settings_repository.dart';
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
    final settingsRepository = FirestoreSettingsRepository(
        repository: repository,
        cacheHelper: cacheHelper);
    final settingsUseCase = SettingsUseCase(
        repository: settingsRepository);
    final connectivityProvider = ConnectivityProvider();
    return BlocProvider(
        create: (context) =>
        SettingsCubit(
            settingsUseCase: settingsUseCase,
            connectivityProvider: connectivityProvider)
          ..getInfo()
          ..startMonitoring(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final cubit = SettingsCubit.get(context);
              return state.when(
                onInitial: () =>
                const InitialStateWidget(),
                onLoading: () =>
                const LoadingStateWidget(),
                onLoaded: (loadedState) =>
                    SettingsLayout(
                      userModel: loadedState.firstModel,
                      messageResult: loadedState.secondModel,
                      onUpdate: (userModel) =>
                          cubit.updateInfo(
                              userName: userModel.userName,
                              userPhone: userModel.userPhone,
                              userLocation: userModel.userLocation
                          ),
                    ),
                onError: (error) =>
                    ErrorStateWidget(error: error.message,
                        onRetry: () => cubit.getInfo()),
              );
            }
        )
    );
  }
}