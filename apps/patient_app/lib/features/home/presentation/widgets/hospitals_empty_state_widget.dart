import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

/// Empty state widget shown when no hospitals are found
class HospitalsEmptyStateWidget extends StatelessWidget {
  const HospitalsEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.vw(3),
              vertical: context.vh(1),
            ),
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
                  padding: EdgeInsets.all(context.vw(3)),
                  decoration: BoxDecoration(
                    color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: context.vw(8),
                    color: ArogyaSewaColors.primaryColor,
                  ),
                ),
                SizedBox(height: context.vh(1.5)),
                Text(
                  noHospitalsNearbyString,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite
                            : ArogyaSewaColors.textColorBlack,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.vh(0.5)),
                Text(
                  noHospitalsNearbyDescString,
                  style: TextStyle(
                    color: ArogyaSewaColors.textColorGrey,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
