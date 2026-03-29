import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

/// Error widget for doctors list with retry option
class DoctorsErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DoctorsErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: EdgeInsets.all(context.vw(4)),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(context.vw(4)),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: context.vw(10),
                color: Colors.red,
              ),
            ),
            SizedBox(height: context.vh(2)),
            Text(
              failedToFetchDoctorsString,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite
                        : ArogyaSewaColors.textColorBlack,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.vh(1)),
            Text(
              message,
              style: TextStyle(
                color: ArogyaSewaColors.textColorGrey,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.vh(2.5)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  retryString,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ArogyaSewaColors.primaryColor,
                  foregroundColor: ArogyaSewaColors.textColorWhite,
                  padding: EdgeInsets.symmetric(
                    vertical: context.vh(1.5),
                    horizontal: context.vw(4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
