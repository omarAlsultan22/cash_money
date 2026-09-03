import 'package:cash_money/core/presentation/states/base/main_loaded_state.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/data/models/user_model.dart';


class SettingsSuccessStateModel extends LoadedState{
  final UserModel userModel;
  final MessageResult messageResult;
  const SettingsSuccessStateModel({
    required this.userModel,
    required this.messageResult,
  });
}