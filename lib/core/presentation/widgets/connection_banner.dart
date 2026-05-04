import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import 'package:cash_money/core/constants/app_durations.dart';


class ConnectionBanner extends StatefulWidget {
  final bool isVisible;
  final Color bgColor;
  final int duration;

  const ConnectionBanner({
    super.key,
    required this.isVisible,
    required this.bgColor,
    this.duration = 0,
 });

  @override
  _ConnectionBannerState createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  late double _height;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _height = 40.0;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    if (widget.duration > 0) {
      _timer = Timer(Duration(seconds: widget.duration), () {
        _hideBanner();
      });
    }
  }

  void _hideBanner() {
    if (mounted) {
      setState(() {
        _height = AppSizes.none;
      });
    }
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: AppDurations.millSeconds),
      curve: Curves.easeInOut,
      height: _height,
      color: widget.bgColor,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}