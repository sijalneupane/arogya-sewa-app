import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

/// Reusable app bar widget for consistent navigation across the app
class ArogyaSewaAppBar {
  /// Creates a standard app bar with back button
  static PreferredSizeWidget create({
    required BuildContext context,
    required String title,
    bool showBackButton = true,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    double elevation = 0,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor ??
              (isDarkMode
                  ? ArogyaSewaColors.textColorWhite
                  : ArogyaSewaColors.textColorBlack),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor ??
          (isDarkMode
              ? ArogyaSewaColors.primaryColor
              : ArogyaSewaColors.textColorWhite),
      elevation: elevation,
      actions: actions,
    );
  }

  /// Creates a loading shimmer app bar for detail pages
  static Widget createLoadingSliverAppBar(BuildContext context, {
    double expandedHeight = 280,
    bool showProfilePlaceholder = true,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: isDarkMode
          ? ArogyaSewaColors.primaryColor
          : ArogyaSewaColors.textColorWhite,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: ArogyaSewaColors.textColorWhite,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [
                      ArogyaSewaColors.primaryColor,
                      ArogyaSewaColors.primaryColor.withValues(alpha: 0.85),
                    ]
                  : [
                      ArogyaSewaColors.primaryColor.withValues(alpha: 0.08),
                      ArogyaSewaColors.textColorWhite,
                    ],
            ),
          ),
          child: showProfilePlaceholder
              ? Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ArogyaSewaColors.shimmerBaseDark
                          : ArogyaSewaColors.shimmerBaseLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
