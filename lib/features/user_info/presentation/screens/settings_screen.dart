import '../../../../core/widgets/states/error_states/no_internet_connection_state.dart';
import 'package:cash_money/features/user_info/domain/useCases/user_info_useCase.dart';
import '../../data/repositories_impl/firestore_user_info_repository.dart';
import '../../../../core/widgets/states/error_states/error_state.dart';
import 'package:cash_money/core/widgets/states/loading_state.dart';
import '../../../../core/widgets/states/initial_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/layouts/settings_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/update_user_info_state.dart';
import '../cubits/Updateuser_Info_cubit.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = FirebaseFirestore.instance;
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final userInfoUseCase = UserInfoUseCase(
        userInfoRepository: userInfoRepository);
    return BlocProvider(
        create: (context) =>
            UpdateUserInfoCubit(userInfoUseCase: userInfoUseCase),
        child: BlocBuilder<UpdateUserInfoCubit, UpdateUserInfoState>(
            builder: (context, state) {
              final cubit = UpdateUserInfoCubit.get(context);
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
