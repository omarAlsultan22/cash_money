import 'package:cash_money/core/presentation/widgets/states/error_states/connection_error_state.dart';
import 'package:flutter/cupertino.dart';


class ConnectivityAwareService extends StatelessWidget {
  final Widget child;
  final bool isConnected;

  const ConnectivityAwareService({
    super.key,
    required this.child,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      return ConnectionErrorStateWidget(onRetry: () => Navigator.pop(context));
    }
    return child;
  }
}