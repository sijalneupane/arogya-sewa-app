import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

class AppThemeData {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ArogyaSewaColors.primaryColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ArogyaSewaColors.scaffoldBackgroundColorLight,
      textTheme: GoogleFonts.poppinsTextTheme(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ArogyaSewaColors.scaffoldBackgroundColorLight,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ArogyaSewaColors.textColorBlack,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ArogyaSewaColors.scaffoldBackgroundColorLight,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: ArogyaSewaColors.textColorBlack,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.cairo(),
        unselectedLabelStyle: GoogleFonts.cairo(),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ArogyaSewaColors.primaryColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ArogyaSewaColors.scaffoldBackgroundColorDark,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ArogyaSewaColors.scaffoldBackgroundColorDark,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ArogyaSewaColors.textColorWhite,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ArogyaSewaColors.scaffoldBackgroundColorDark,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: ArogyaSewaColors.textColorWhite,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.cairo(),
        unselectedLabelStyle: GoogleFonts.cairo(),
      ),
    );
  }
}
