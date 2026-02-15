import 'package:cash_money/features/questions/presentation/states/base/data_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../cubits/data_cubit.dart';


class CallRestLockIfNeeded extends StatelessWidget {
  final Widget child;
  final DataState state;

  const CallRestLockIfNeeded({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    _callRestLockIfNeeded(context);
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