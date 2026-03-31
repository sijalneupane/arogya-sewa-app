import 'package:flutter/material.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_core/utils/date_formatter.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';

/// Reusable card widget for displaying doctor availability information
class AvailabilityCard extends StatelessWidget {
  final DoctorAvailabilityEntity availability;
  final VoidCallback? onTap;
  final bool showBookButton;

  const AvailabilityCard({
    super.key,
    required this.availability,
    this.onTap,
    this.showBookButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isAvailable = !availability.isBooked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1D255F)
              : ArogyaSewaColors.textColorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAvailable
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isAvailable
                  ? Colors.green.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date and time indicator
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isAvailable
                    ? Colors.green.withValues(alpha: 0.08)
                    : Colors.grey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isAvailable
                    ? Icons.event_available_rounded
                    : Icons.event_busy_rounded,
                color: isAvailable ? Colors.green : Colors.grey,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            // Availability details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.5)
                            : ArogyaSewaColors.textColorGrey,
                      ),
                      SizedBox(width: 6),
                      FutureBuilder<String?>(
                        future: DateFormatter.convertAdToBsFormatted(
                          availability.startDateTime.toIso8601String(),
                        ),
                        builder: (context, snapshot) {
                          final bsDate = snapshot.data ?? _formatDate(availability.startDateTime);
                          return Text(
                            bsDate,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? ArogyaSewaColors.textColorWhite
                                  : ArogyaSewaColors.textColorBlack,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.5)
                            : ArogyaSewaColors.textColorGrey,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '${DateFormatter.formatTime(availability.startDateTime.toIso8601String())} - ${DateFormatter.formatTime(availability.endDateTime.toIso8601String())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                              : ArogyaSewaColors.textColorGrey,
                        ),
                      ),
                    ],
                  ),
                  // Status badge
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAvailable
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 12,
                          color: isAvailable ? Colors.green : Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          isAvailable ? 'Available' : 'Booked',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isAvailable ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Book button (optional)
            if (showBookButton && isAvailable)
              ArogyaSewaButton(
                onPressed: onTap,
                width: 80,
                height: 36,
                // gradient: ArogyaSewaColors.primrayGraidient,
                backgroundColor: ArogyaSewaColors.primaryColor,
                foregroundColor: ArogyaSewaColors.textColorWhite,
                child: Text(
                  'Book',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    // color: ArogyaSewaColors.textColorWhite,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormatter.formatDateFull(dateTime.toIso8601String());
  }
}
