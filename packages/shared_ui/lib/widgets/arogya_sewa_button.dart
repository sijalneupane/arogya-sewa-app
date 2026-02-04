import 'package:flutter/material.dart';

class ArogyaSewaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  const ArogyaSewaButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}