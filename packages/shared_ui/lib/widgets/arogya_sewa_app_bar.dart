import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    double? elevation,
  }) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    return AppBar(
      leading: showBackButton
          ? IconButton(
              onPressed: () =>context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: foregroundColor ?? appBarTheme.foregroundColor,
              ),
            )
          : null,
      title: Text(
        title,
        style: appBarTheme.titleTextStyle?.copyWith(
          color: foregroundColor ?? appBarTheme.foregroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      elevation: elevation ?? appBarTheme.elevation,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      actions: actions,
    );
  }

  /// Creates a loading shimmer app bar for detail pages
  static Widget createLoadingSliverAppBar(BuildContext context, {
    double expandedHeight = 280,
    bool showProfilePlaceholder = true,
  }) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation,
      foregroundColor: appBarTheme.foregroundColor,
      leading: IconButton(
        onPressed: () =>context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: appBarTheme.foregroundColor,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.brightness == Brightness.dark
                  ? [
                      ArogyaSewaColors.primaryColor,
                      ArogyaSewaColors.primaryColor.withValues(alpha: 0.85),
                    ]
                  : [
                      ArogyaSewaColors.primaryColor.withValues(alpha: 0.08),
                      colorScheme.surface,
                    ],
            ),
          ),
          child: showProfilePlaceholder
              ? Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
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
