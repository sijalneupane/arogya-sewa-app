import 'package:flutter/material.dart';
/*
  * This file is used to define the colors used in the app
  * Don't use hardcoded color values in the app
 */
class ArogyaSewaColors {
  //primary color
  static const  Color primaryColor = Color(0xFF1A205C);
  static const Color secondaryColor =  Color(0xFF0D47A1);

  static const Color transparent = Colors.transparent;

  //text colors
  static const Color textColorWhite = Colors.white;
  static const Color textColorBlack = Colors.black;
   static const Color textColorGrey = Colors.grey;

  //border and text colors
  static const Color borderColorWhite = Color(0xFF333333);
  static const Color borderColorBlack = Color(0xFFDDDDDD);
  static const Color borderColorGrey = Color(0xFFB9B3B3);
  static const Color dialogBoxColor = Color(0xFFF8F8F8);

  //scaffold background color
  static const Color scaffoldBackgroundColorLight = Color(0xFFFAFAFA);
  static const Color scaffoldBackgroundColorDark = Color(0xFF1F1F1F);


  // textformfield colors 
  static const textformfieldColor = Colors.white;
  static const textformfieldColorDark =Color(0xFF343434);
  
  //gradient color
  static LinearGradient primrayGraidient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, secondaryColor.withAlpha((255 * 0.8).round())],
  );

  // shimmer colors for loading states
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF3A3A3A);
  static const Color shimmerHighlightDark = Color(0xFF4A4A4A);
}
