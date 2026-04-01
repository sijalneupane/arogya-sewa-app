import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

/// Global loading popup dialog with SpinKit loader
/// 
/// Features:
/// - Non-dismissible by tapping outside
/// - Blur backdrop effect
/// - Centered loading indicator with message
/// - Theme-aware colors
class ArogyaSewaLoadingDialog extends StatelessWidget {
  final String message;
  final Color? loaderColor;

  const ArogyaSewaLoadingDialog({
    super.key,
    this.message = 'Loading...',
    this.loaderColor,
  });

  /// Show the loading dialog
  /// Returns a Future that completes when the dialog is closed
  static Future<void> show({
    required BuildContext context,
    String message = 'Loading...',
    Color? loaderColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => ArogyaSewaLoadingDialog(
        message: message,
        loaderColor: loaderColor,
      ),
    );
  }

  /// Hide the loading dialog
  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ArogyaSewaColors.cardBackgroundColorDark
                : ArogyaSewaColors.cardBackgroundColorLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Loading Spinner
              SpinKitFadingCircle(
                color: loaderColor ?? ArogyaSewaColors.primaryColor,
                size: 50,
              ),
              const SizedBox(height: 20),
              // Loading Message
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
