import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      onPrimaryPressed: () => context.pop(),
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
      onPrimaryPressed: () => context.pop(),
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
      onPrimaryPressed: () => context.pop(),
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
      onPrimaryPressed: () => context.pop(),
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
    // final colorScheme = theme.colorScheme;
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
            horizontal: 32,
            vertical: 24,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1C1C1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title with Icon (Left or Right based on dialog type)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (icon != null && dialogType != _DialogType.confirm) ...[
                              Icon(
                                icon,
                                color: iconColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF1C1C1E),
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (icon != null && dialogType == _DialogType.confirm) ...[
                              Icon(
                                icon,
                                color: iconColor,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Message
                        Text(
                          message,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.7)
                                : const Color(0xFF6C6C70),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    height: 0.5,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFE5E5EA),
                  ),

                  // Buttons Section
                  isTwoButton
                      ? Row(
                          children: [
                            // Cancel Button (Left)
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => context.pop(),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      secondaryButtonText ?? 'Cancel',
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white.withValues(alpha: 0.7)
                                            : const Color(0xFF8E8E93),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Vertical Divider
                            Container(
                              width: 0.5,
                              height: 40,
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : const Color(0xFFE5E5EA),
                            ),
                            // Confirm Button (Right)
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context.pop();
                                    onPrimaryPressed();
                                  },
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(16),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      primaryButtonText,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: iconColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onPrimaryPressed,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              child: Text(
                                primaryButtonText,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: iconColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _DialogType { confirm, info, success, warning, error }