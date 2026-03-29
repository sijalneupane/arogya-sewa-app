import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';

class ArogyaSewaRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData icon;
  final String? buttonText;
  final bool showIcon;
  final bool useCard;

  const ArogyaSewaRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
    this.buttonText,
    this.showIcon = true,
    this.useCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            /// Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
          ],

          /// Error Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 25),

          /// Retry Button
          ArogyaSewaButton(
            onPressed: onRetry,
            gradient: ArogyaSewaColors.primrayGraidient,
            foregroundColor: ArogyaSewaColors.textColorWhite,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh),
                const SizedBox(width: 8),
                Text(buttonText ?? "Retry"),
              ],
            ),
          ),
        ],
      ),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: useCard
            ? Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}