import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

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
                      Text(
                        _formatDate(availability.startDateTime),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? ArogyaSewaColors.textColorWhite
                              : ArogyaSewaColors.textColorBlack,
                        ),
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
                        '${_formatTime(availability.startDateTime)} - ${_formatTime(availability.endDateTime)}',
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
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ArogyaSewaColors.primaryColor,
                  foregroundColor: ArogyaSewaColors.textColorWhite,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Book',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }
}
