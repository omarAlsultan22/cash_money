import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/models/message_result.dart';
import 'package:cash_money/core/presentation/states/base/main_loaded_state.dart';


class SettingsSuccessState extends LoadedState{
  final UserModel userModel;
  final MessageResult messageResult;
  const SettingsSuccessState({
    required this.userModel,
    required this.messageResult,
  });
}