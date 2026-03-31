import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

/// Global project-wide reusable dialog modal
///
/// iPhone/iOS style dialogs with professional design
/// Supports both light and dark themes automatically
/// Tap outside to dismiss
class ArogyaSewaDialogs {
  /// ✅ Confirm Dialog (with Cancel & Confirm buttons)
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    IconData? icon,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
  }) async {
    return _showBaseDialog(
      context: context,
      title: title,
      message: message,
      icon: icon,
      iconColor: ArogyaSewaColors.primaryColor,
      primaryButtonText: confirmText,
      secondaryButtonText: cancelText,
      onPrimaryPressed: onConfirm,
      isTwoButton: true,
      dialogType: _DialogType.confirm,
    );
  }

  /// ℹ️ Info Dialog (single OK button)
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String buttonText = 'OK',
  }) async {
    return _showBaseDialog(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.info_outline_rounded,
      iconColor: ArogyaSewaColors.primaryColor,
      primaryButtonText: buttonText,
      onPrimaryPressed: () => Navigator.pop(context),
      isTwoButton: false,
      dialogType: _DialogType.info,
    );
  }

  /// ✅ Success Dialog (single OK button)
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String buttonText = 'Done',
  }) async {
    return _showBaseDialog(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.check_circle_rounded,
      iconColor: const Color(0xFF34C759),
      primaryButtonText: buttonText,
      onPrimaryPressed: () => Navigator.pop(context),
      isTwoButton: false,
      dialogType: _DialogType.success,
    );
  }

  /// ⚠️ Warning Dialog (single OK button)
  static Future<void> showWarningDialog({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String buttonText = 'OK',
  }) async {
    return _showBaseDialog(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.warning_rounded,
      iconColor: const Color(0xFFFF9500),
      primaryButtonText: buttonText,
      onPrimaryPressed: () => Navigator.pop(context),
      isTwoButton: false,
      dialogType: _DialogType.warning,
    );
  }

  /// ❌ Error Dialog (single Close button)
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String buttonText = 'OK',
  }) async {
    return _showBaseDialog(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.error_rounded,
      iconColor: const Color(0xFFFF3B30),
      primaryButtonText: buttonText,
      onPrimaryPressed: () => Navigator.pop(context),
      isTwoButton: false,
      dialogType: _DialogType.error,
    );
  }

  /// 🔹 Base Dialog Builder (shared by all)
  static Future<void> _showBaseDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Color iconColor,
    IconData? icon,
    required String primaryButtonText,
    String? secondaryButtonText,
    required VoidCallback onPrimaryPressed,
    bool isTwoButton = false,
    required _DialogType dialogType,
  }) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Content Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF2C2C2E)
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      if (icon != null) ...[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Title
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF1C1C1C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Message
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.6)
                              : const Color(0xFF8E8E93),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Buttons Section
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF2C2C2E)
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: isTwoButton
                      ? Row(
                          children: [
                            // Cancel Button (Left)
                            Expanded(
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    secondaryButtonText ?? 'Cancel',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF007AFF),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Divider
                            Container(
                              width: 0.5,
                              height: 44,
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : const Color(0xFFC6C6C8),
                            ),
                            // Confirm Button (Right)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  onPrimaryPressed();
                                },
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(14),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    primaryButtonText,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF007AFF),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: onPrimaryPressed,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            child: Text(
                              primaryButtonText,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF007AFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum _DialogType { confirm, info, success, warning, error }
