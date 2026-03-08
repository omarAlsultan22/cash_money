import '../../../../core/presentation/widgets/states/error_states/no_internet_connection_state.dart';
import '../../../../core/presentation/widgets/states/error_states/error_state.dart';
import 'package:cash_money/features/settings/domain/useCases/settings_useCase.dart';
import '../../../../core/presentation/widgets/states/initial_state.dart';
import '../../../../core/presentation/widgets/states/loading_state.dart';
import '../../data/repositories_impl/settings_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/layouts/settings_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/settings_state.dart';
import '../cubits/settings_cubit.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = FirebaseFirestore.instance;
    final settingsRepository = FirestoreSettingsRepository(repository: repository);
    final settingsUseCase = SettingsUseCase(
        repository: settingsRepository);
    return BlocProvider(
        create: (context) =>
            SettingsCubit(settingsUseCase: settingsUseCase),
        child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final cubit = SettingsCubit.get(context);
              return state.when(
                onInitial: () =>
                const InitialStateWidget(),
                onLoading: () =>
                const LoadingStateWidget(),
                onLoaded: () =>
                    SettingsLayout(
                        userName: state.userName,
                        userPhone: state.userPhone,
                        userLocation: state.userLocation
                    ),
                onError: (error) =>
                error.isConnectionError
                    ? ConnectionErrorStateWidget(error: error.message,
                    onRetry: () => cubit.getInfo())
                    : ErrorStateWidget(error: error.message,
                    onRetry: () => cubit.getInfo()),
              );
            }
        )
    );
  }
}
