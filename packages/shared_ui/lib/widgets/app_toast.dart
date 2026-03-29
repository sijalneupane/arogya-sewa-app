import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Toast types supported by the app
enum AppToastType {
  success,
  error,
  warning,
  info,
}

/// Global reusable toast utility for the Arogya Sewa monorepo
///
/// Usage:
/// ```dart
/// // Success toast
/// AppToast.show(context, 'Operation successful!', type: AppToastType.success);
///
/// // Error toast
/// AppToast.show(context, 'Something went wrong', type: AppToastType.error);
///
/// // With custom duration
/// AppToast.show(context, 'Processing...', type: AppToastType.info, duration: const Duration(seconds: 5));
/// ```
class AppToast {
  /// Show a toast notification
  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final typeConfig = _getTypeConfig(type);

    toastification.show(
      context: context,
      type: typeConfig.toastType,
      style: ToastificationStyle.flatColored,
      title: title != null
          ? Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            )
          : null,
      description: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      icon: Icon(typeConfig.icon, color: typeConfig.iconColor),
      backgroundColor: typeConfig.backgroundColor,
      foregroundColor: typeConfig.foregroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      showIcon: true,
      showProgressBar: false,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Show a success toast
  static void success(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: AppToastType.success, title: title, duration: duration);
  }

  /// Show an error toast
  static void error(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(context, message, type: AppToastType.error, title: title, duration: duration);
  }

  /// Show a warning toast
  static void warning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: AppToastType.warning, title: title, duration: duration);
  }

  /// Show an info toast
  static void info(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: AppToastType.info, title: title, duration: duration);
  }

  /// Close all visible toasts
  static void closeAll() {
    toastification.dismissAll();
  }

  static _ToastTypeConfig _getTypeConfig(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return _ToastTypeConfig(
          toastType: ToastificationType.success,
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF22C55E),
          backgroundColor: const Color(0xFFF0FDF4),
          foregroundColor: const Color(0xFF166534),
        );
      case AppToastType.error:
        return _ToastTypeConfig(
          toastType: ToastificationType.error,
          icon: Icons.error_rounded,
          iconColor: const Color(0xFFEF4444),
          backgroundColor: const Color(0xFFFEF2F2),
          foregroundColor: const Color(0xFF991B1B),
        );
      case AppToastType.warning:
        return _ToastTypeConfig(
          toastType: ToastificationType.warning,
          icon: Icons.warning_rounded,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFFEFCE8),
          foregroundColor: const Color(0xFF854D0E),
        );
      case AppToastType.info:
        return _ToastTypeConfig(
          toastType: ToastificationType.info,
          icon: Icons.info_rounded,
          iconColor: const Color(0xFF3B82F6),
          backgroundColor: const Color(0xFFEFF6FF),
          foregroundColor: const Color(0xFF1E40AF),
        );
    }
  }
}

class _ToastTypeConfig {
  final ToastificationType toastType;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color foregroundColor;

  _ToastTypeConfig({
    required this.toastType,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}
