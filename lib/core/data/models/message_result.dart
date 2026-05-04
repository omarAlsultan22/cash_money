import 'dart:ui';
import '../../constants/app_colors.dart';
import '../../errors/exceptions/base/app_exception.dart';


class MessageResult {
  final String? error;
  final bool isLoading;
  final String? message;
  final Color? color;

  MessageResult({
    this.isLoading = false,
    this.message,
    this.error,
    this.color
  });


  factory MessageResult.loading(){
    return MessageResult(
        isLoading: true
    );
  }

  factory MessageResult.success(){
    return MessageResult(
        isLoading: false,
        color: AppColors.successGreen,
        message: 'Updated Successfully'
    );
  }

  factory MessageResult.error({
    AppException? error,
  }){
    return MessageResult(
        isLoading: false,
        color: AppColors.errorRed,
        message: 'Update failed: ${error!.message}'
    );
  }
}