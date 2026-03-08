import 'dart:async';
import 'package:cash_money/core/presentation/widgets/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:cash_money/core/constants/app_colors.dart';


class ConnectionBanner extends StatefulWidget {
  final bool isVisible;
  final Color bgColor;
  final IconData icon;
  final String text;
  final int duration;
  final VoidCallback? reload;

  const ConnectionBanner({
    super.key,
    required this.isVisible,
    required this.bgColor,
    required this.icon,
    required this.text,
    this.duration = 0,
    this.reload
  });

  @override
  _ConnectionBannerState createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  late double _height;
  Timer? _timer;

  static const _zero = 0;
  static const _white = AppColors.white;

  @override
  void initState() {
    super.initState();
    _height = 40.0;
    _restLocks();
    _startTimer();
  }


  void _restLocks() {
    if (widget.isVisible) {
      widget.reload!();
    }
  }

  void _startTimer() {
    _timer?.cancel();

    if (widget.duration > _zero) {
      _timer = Timer(Duration(seconds: widget.duration), () {
        _hideBanner();
      });
    }
  }

  void _hideBanner() {
    if (mounted) {
      setState(() {
        _height = 0.0;
      });
    }
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _height,
      color: widget.bgColor,
      child: _height > _zero
          ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: _white),
            AppSpacing.height_8,
            Text(
              widget.text,
              style: const TextStyle(
                color: _white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}