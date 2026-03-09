import 'package:flutter/material.dart';
/*
  * This file is used to define the colors used in the app
  * Don't use hardcoded color values in the app
 */
class DoctorAppColors {
  //primary color
  static const  Color primaryColor = Color(0xff1b2a59);
  static const Color secondaryColor = Color(0xff276185);

  static const Color transparent = Colors.transparent;

  //text colors
  static const Color textColorWhite = Colors.white;
  static const Color textColorBlack = Colors.black;
   static const Color textColorGrey = Colors.grey;

  //border and text colors
  static const Color borderColorWhite = Color(0xFF333333);
  static const Color borderColorBlack = Color(0xFFFAFAFA);
  static const Color borderColorGrey = Color(0xFFB9B3B3);
  static const Color dialogBoxColor = Color(0xFFF8F8F8);

  //scaffold background color
  static const Color scaffoldBackgroundColorLight = Color(0xFFFAFAFA);
  static const Color scaffoldBackgroundColorDark = Color(0xFF1F1F1F);


  
  //gradient color
  static LinearGradient primrayGraidient = LinearGradient(
    colors: [primaryColor, primaryColor.withAlpha((255 * 0.8).round())],
  );
}
