import '../cubits/data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cash_money/features/questions/presentation/states/base/data_state.dart';


class ConnectivityAwareScreen extends StatelessWidget {
  final Widget child;
  final DataState state;
  final bool isConnected;

  const ConnectivityAwareScreen({
    super.key,
    required this.state,
    required this.child,
    required this.isConnected
  });

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      _callRestLockIfNeeded(context);
    }
    return child;
  }

  void _callRestLockIfNeeded(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final newsCubit = context.read<DataCubit>();
        newsCubit.restLock(state);
      } catch (e) {
        debugPrint('Error calling restLock: $e');
      }
    });
  }
}