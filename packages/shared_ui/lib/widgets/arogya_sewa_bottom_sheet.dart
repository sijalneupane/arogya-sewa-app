import 'package:flutter/material.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';

enum BottomSheetType { success, info, error }

class ArogyaSewaBottomSheet {
  /// Displays a customizable modal bottom sheet with an icon and message.
  ///
  /// [context]: The BuildContext used to show the bottom sheet.
  /// [type]: The type of bottom sheet (success, info, or error).
  /// [message]: The message to display in the bottom sheet.
  /// [duration]: Duration after which the bottom sheet auto-dismisses (default: 2 seconds).
  /// [onDismissed]: Optional callback when the bottom sheet is dismissed.
  /// [executeCallbackAfterDismiss]: If true, onDismissed callback executes after auto-dismiss (default: true).
  /// [isDismissible]: Whether the bottom sheet can be dismissed by tapping outside/swipe (default: false).
  /// [enableDrag]: Whether the bottom sheet can be dragged (default: false).
  /// [useRootNavigator]: If true, shows the sheet over the root navigator (overlays bottom nav bar).
  /// [iconSize]: Size of the icon (default: 30).
  /// [horizontalPadding]: Horizontal padding for the message text (default: 16.0).
  /// [verticalPadding]: Vertical padding for the container (default: 16).
  /// [horizontalContainerPadding]: Horizontal padding for the container (default: 8).
  Future<void> showAppBottomSheet(
    BuildContext context, {
    required BottomSheetType type,
    required String message,
    BuildContext? parentContext,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onDismissed,
    bool executeCallbackAfterDismiss = true,
    bool isDismissible = false,
    bool enableDrag = false,
    bool useRootNavigator = true,
    double iconSize = 30,
    double horizontalPadding = 16.0,
    double verticalPadding = 16,
    double horizontalContainerPadding = 8,
  }) async {
    // Use root navigator context if requested (overlays shell/bottom nav)
    final BuildContext sheetContext = parentContext ?? context;

    final Color color;
    final IconData icon;
    final String defaultMessage;

    switch (type) {
      case BottomSheetType.success:
        icon = Icons.check_circle;
        color = Colors.green;
        defaultMessage = defaultSuccessMessage;
        break;
      case BottomSheetType.info:
        icon = Icons.info;
        color = Colors.blue;
        defaultMessage = defaultInfoMessage;
        break;
      case BottomSheetType.error:
        icon = Icons.error;
        color = Colors.red;
        defaultMessage = defaultErrorSting;
        break;
    }

    // Show the bottom sheet and store the result
    await showModalBottomSheet<void>(
      context: sheetContext,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (BuildContext innerContext) {
        // Set up auto-dismiss with duration
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(duration, () {
            if (innerContext.mounted && Navigator.of(innerContext).canPop()) {
              Navigator.of(innerContext).pop();
            }
          });
        });

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalContainerPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: iconSize),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  message.isNotEmpty ? message : defaultMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: color,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    // Execute callback after bottom sheet dismisses if flag is enabled
    if (executeCallbackAfterDismiss) {
      onDismissed?.call();
    }
  }
}