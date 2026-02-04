import 'package:flutter/material.dart';

class ArogyaSewaTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool? autofocus;
  final Widget? icon;
  final Widget label;
  final IconAlignment? iconAlignment;
  const ArogyaSewaTextButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.autofocus,
    this.icon,
    required this.label,
    this.iconAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: label,
      icon: icon,
      iconAlignment: iconAlignment,
      style:style ?? ButtonStyle(
        foregroundColor: Theme.of(context).textButtonTheme.style?.foregroundColor,
      ),
    );
  }
}
