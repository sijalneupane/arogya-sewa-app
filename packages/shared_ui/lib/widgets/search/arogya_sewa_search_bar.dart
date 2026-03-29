import 'package:flutter/material.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

/// A reusable, customizable search bar widget that displays a search field with an icon.
/// The search bar is design-only with onTap functionality to navigate to a search screen.
class ArogyaSewaSearchBar extends StatelessWidget {
  /// Callback function triggered when the search bar is tapped
  final VoidCallback? onTap;

  /// Hint text displayed in the search bar
  final String hintText;

  /// Icon to display in the search bar (defaults to search icon)
  final IconData? prefixIcon;

  /// Color of the hint text (optional, uses theme color if not provided)
  final Color? hintTextColor;

  /// Color of the icon (optional)
  final Color? iconColor;

  /// Border color (optional)
  final Color? borderColor;

  /// Background color (optional)
  final Color? backgroundColor;

  /// Border radius (optional, defaults to 12)
  final double borderRadius;

  /// Padding (optional)
  final EdgeInsets? padding;

  /// Height of the search bar (optional, defaults to 48)
  final double? height;

  const ArogyaSewaSearchBar({
    super.key,
    this.onTap,
    this.hintText = 'Search...',
    this.prefixIcon = Icons.search,
    this.hintTextColor,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 12,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final effectiveHintColor = hintTextColor ??
        (isDarkMode
            ? ArogyaSewaColors.textColorGrey
            : ArogyaSewaColors.textColorGrey);
    final effectiveIconColor = iconColor ??
        (isDarkMode
            ? ArogyaSewaColors.textColorWhite
            : ArogyaSewaColors.textColorBlack);
    final effectiveBgColor = backgroundColor ??
        (isDarkMode
            ? ArogyaSewaColors.primaryColor.withOpacity(0.1)
            : Colors.grey.shade100);
    final effectiveBorderColor = borderColor ?? Colors.transparent;

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: context.vw(2.5)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 48,
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: context.vw(3)),
              Icon(
                prefixIcon,
                color: effectiveIconColor,
                size: 20,
              ),
              SizedBox(width: context.vw(2)),
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    color: effectiveHintColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: context.vw(3)),
            ],
          ),
        ),
      ),
    );
  }
}
