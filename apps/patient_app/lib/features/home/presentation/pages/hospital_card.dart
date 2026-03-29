import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/common/model/hospital_entity.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

class HospitalCard extends StatelessWidget {
  final HospitalEntity hospital;
  final VoidCallback? onTap;

  const HospitalCard({
    super.key,
    required this.hospital,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite
        : ArogyaSewaColors.textColorBlack;
    final hintColor = ArogyaSewaColors.textColorGrey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.vh(2)),
        padding: EdgeInsets.all(context.vw(3)),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? ArogyaSewaColors.primaryColor.withOpacity(0.2)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospital.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.vh(1)),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: ArogyaSewaColors.primaryColor,
                  size: 16,
                ),
                SizedBox(width: context.vw(1.5)),
                Expanded(
                  child: Text(
                    hospital.location,
                    style: TextStyle(
                      color: hintColor,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.vh(1)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contactString,
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: context.vh(0.5)),
                      Text(
                        hospital.contactNumber.isNotEmpty
                            ? hospital.contactNumber.first
                            : 'N/A',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        openedDateString,
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: context.vh(0.5)),
                      Text(
                        hospital.openedDate.split('T').first,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
