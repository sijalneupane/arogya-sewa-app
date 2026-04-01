import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

/// Reusable delete icon button widget
/// 
/// Features:
/// - Red color in light theme
/// - White color in dark theme
/// - Small compact size
/// - Optional confirmation callback
class ArogyaSewaDeleteIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  const ArogyaSewaDeleteIconButton({
    super.key,
    this.onPressed,
    this.size = 28,
    this.iconSize = 16,
    this.padding,
    this.tooltip = 'Delete',
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.primaryColor
            : Colors.red.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: padding ?? EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          Icons.delete_outline_rounded,
          size: iconSize,
          color: isDarkMode
              ? ArogyaSewaColors.textColorWhite
              : Colors.red,
        ),
        tooltip: tooltip,
      ),
    );
  }
}
