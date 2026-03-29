import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

/// Widget shown when location permission is not granted
class LocationPermissionWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const LocationPermissionWidget({
    super.key,
    required this.onRequestPermission,
  });

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
              gradient: isDarkMode
                  ? LinearGradient(
                      colors: [
                        ArogyaSewaColors.primaryColor.withValues(alpha: 0.2),
                        ArogyaSewaColors.primaryColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isDarkMode
                  ? null
                  : ArogyaSewaColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(context.vw(3)),
                  decoration: BoxDecoration(
                    color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_off_rounded,
                    size: context.vw(8),
                    color: ArogyaSewaColors.primaryColor,
                  ),
                ),
                SizedBox(height: context.vh(1.5)),
                Text(
                  locationPermissionTitleString,
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
                  locationPermissionDescString,
                  style: TextStyle(
                    color: ArogyaSewaColors.textColorGrey,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.vh(1.5)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRequestPermission,
                    icon: const Icon(Icons.location_searching, size: 18),
                    label: Text(
                      grantPermissionString,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ArogyaSewaColors.primaryColor,
                      foregroundColor: ArogyaSewaColors.textColorWhite,
                      padding: EdgeInsets.symmetric(
                        vertical: context.vh(1),
                        horizontal: context.vw(3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
