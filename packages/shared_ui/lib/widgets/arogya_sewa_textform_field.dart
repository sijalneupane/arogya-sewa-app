import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

// ignore: must_be_immutable
class ArogyaSewaTextFormField extends StatelessWidget {
  String? outerLabel;
  String? labelText;
  String? hintText;
  List<TextInputFormatter>? inputFormatter;
  bool? obsecureText;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  Widget? suffixIcon;
  bool isVisible;
  bool readOnly;
  Widget? prefixIcon;
  Function()? onTap;
  bool smallTextFormField;
  Function(String)? onChanged;
  TextEditingController? controller;
  int maxLines;
  TextStyle? outerLabelStyle;
  bool? enabled;
  Color? suffixIconColor;
  Color? prefixIconColor;

  ArogyaSewaTextFormField({
    super.key,
    this.smallTextFormField = false,
    this.isVisible = false,
    this.enabled,
    this.onChanged,
    this.labelText,
    this.outerLabel,
    this.onTap,
    this.readOnly = false,
    this.obsecureText,
    this.hintText,
    this.inputFormatter,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.maxLines = 1,
    this.outerLabelStyle,
    this.prefixIconColor,
    this.suffixIconColor,
  });
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = enabled == false
        ? ArogyaSewaColors.textColorGrey
        : (isDarkMode ? ArogyaSewaColors.textColorWhite : ArogyaSewaColors.textColorBlack);
    final fillColor = isDarkMode
        ? ArogyaSewaColors.textformfieldColorDark
        : ArogyaSewaColors.textformfieldColor;
    final defaultIconColor = enabled == false
        ? ArogyaSewaColors.textColorGrey
        : (isDarkMode ? ArogyaSewaColors.textColorWhite : ArogyaSewaColors.textColorBlack);

    final textStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: textColor);
    final double fontSize = smallTextFormField ? 12 : (textStyle?.fontSize ?? 14);
    final contentPadding = EdgeInsets.symmetric(
      vertical:12,
      horizontal: 10,
    );
    final borderRadius = BorderRadius.circular(10);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(
          children: [
            if (outerLabel != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 4.0),
                  child: Text(
                    outerLabel!,
                    style:
                        outerLabelStyle ??
                        Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: enabled == false ? textColor : null,
                        ),
                  ),
                ),
              ),

            TextFormField(
              enabled: enabled,
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              textAlign: TextAlign.start,
              style: textStyle?.copyWith(fontSize: fontSize),
              decoration: InputDecoration(
                isCollapsed: smallTextFormField,
                filled: true,
                fillColor: fillColor,
                contentPadding: contentPadding,
                prefixIcon: prefixIcon,
                prefixIconColor: prefixIconColor ?? defaultIconColor,
                prefixIconConstraints: const BoxConstraints(minWidth: 40.0),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  color: ArogyaSewaColors.textColorGrey,
                ),
                suffixIcon: suffixIcon,
                suffixIconColor: suffixIconColor ?? defaultIconColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    style: isDarkMode ? BorderStyle.none : BorderStyle.solid,
                  ),
                ),
                disabledBorder:  OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    style: isDarkMode ? BorderStyle.none : BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color:  ArogyaSewaColors.primaryColor,
                    width: 2.0,
                  ),
                ),
                errorMaxLines: 2,
              ),
              maxLines: maxLines,
              obscureText: obsecureText ?? false,
              keyboardType: keyboardType,
              inputFormatters: inputFormatter,
              validator: validator,
            ),
          ],
        ),
      ),
    );
  }
}
