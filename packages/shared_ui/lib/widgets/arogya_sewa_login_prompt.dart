import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';

/// A reusable widget that prompts unauthenticated users to log in.
/// Used on pages that require authentication (cart, order, reviews).
class ArogyaSewaLoginPrompt extends StatelessWidget {
  /// The message to display to the user.
  final String message;

  /// Optional callback when login is successful.
  final VoidCallback? onLoginSuccess;
  /// The route name to navigate to for login.
  final String loginRouteName;

  const ArogyaSewaLoginPrompt({
    super.key,
    required this.message,
    this.onLoginSuccess,
    required this.loginRouteName
  });

  @override
Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final effectivePrimaryColor = isDark ? Colors.white : AppColors.primaryColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ArogyaSewaButton(
            width: context.vw(25),
            height: 35,
            gradient: ArogyaSewaColors.primrayGraidient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  loginString,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () async {
              final result = await context.pushNamed(
                loginRouteName,
              extra: true,
            );
            if (result == true && context.mounted) {
              onLoginSuccess?.call();
            }
          })
          // TextButton.icon(
          //   onPressed: () async {
          //     final result = await context.pushNamed(
          //       RoutesName.loginScreen,
          //       extra: const LoginPageArgs(popOnSuccess: true),
          //     );
          //     if (result == true && context.mounted) {
          //       onLoginSuccess?.call();
          //     }
          //   },
          //   iconAlignment: IconAlignment.end,
          //   style: TextButton.styleFrom(
          //     padding: EdgeInsets.zero,
          //     minimumSize: Size.zero,
          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   ),
          //   icon: Icon(
          //     Icons.arrow_forward_ios_rounded,
          //     size: 14,
          //     color: effectivePrimaryColor,
          //   ),
          //   label: Text(
          //     loginString,
          //     style: TextStyle(
          //       color: effectivePrimaryColor,
          //       fontWeight: FontWeight.w600,
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
