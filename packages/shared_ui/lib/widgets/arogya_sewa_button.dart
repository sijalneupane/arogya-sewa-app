import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

class ArogyaSewaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Gradient? gradient;
  final Color? foregroundColor;
  final Widget? child;
  const ArogyaSewaButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.width = double.infinity, // Default to full width
    this.height = 46,
    this.gradient,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // return ElevatedButton(onPressed: onPressed, child: child);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ArogyaSewaColors.transparent,
          foregroundColor: foregroundColor ?? Colors.white,
          minimumSize: Size.fromHeight(45),
          padding: EdgeInsets.zero,
          // Text and Icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
