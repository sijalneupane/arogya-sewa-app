import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';
import 'package:shared_core/utils/date_formatter.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/widgets/arogya_sewa_delete_icon_button.dart';

/// Attractive card widget for displaying appointment information
class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode
                ? ArogyaSewaColors.cardBackgroundColorDark
                : ArogyaSewaColors.cardBackgroundColorLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: _getStatusColor(context).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header with status badge
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getStatusColor(context).withValues(alpha: 0.1),
                    _getStatusColor(context).withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  /// Doctor Profile Image
                  ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ArogyaSewaColors.shimmerBaseDark
                            : ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                        border: Border.all(
                          color: _getStatusColor(context),
                          width: 2,
                        ),
                      ),
                      child: appointment.doctor.user.profileImage != null
                          ? CachedNetworkImage(
                              imageUrl: appointment.doctor.user.profileImage!.fileUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: Icon(
                                  Icons.person,
                                  color: ArogyaSewaColors.primaryColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                color: ArogyaSewaColors.primaryColor,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: ArogyaSewaColors.primaryColor,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Doctor Name and Specialization
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctor.user.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? ArogyaSewaColors.textColorWhite
                                    : ArogyaSewaColors.textColorBlack,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.doctor.department?.name ?? noDepartmentString,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isDarkMode
                                    ? ArogyaSewaColors.textColorWhite
                                        .withValues(alpha: 0.7)
                                    : ArogyaSewaColors.textColorGrey,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  /// Status Badge
                  _buildStatusBadge(context, isDarkMode),
                ],
              ),
            ),

            const Divider(height: 1),

            /// Appointment Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Date and Time Row
                  _buildDateTimeRow(
                    context,
                    dateTime: appointment.availability.startDateTime,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 4),

                  /// Hospital Location
                  _buildDetailRow(
                    context,
                    icon: Icons.location_on_rounded,
                    title: 'Location',
                    value: appointment.doctor.hospital.name,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 4),

                  // /// Appointment Type (In-person/Virtual)
                  // _buildDetailRow(
                  //   context,
                  //   icon: Icons.info_outline_rounded,
                  //   title: 'Consultation',
                  //   value: 'Scheduled Appointment',
                  //   isDarkMode: isDarkMode,
                  // ),
                  // const SizedBox(height: 12),

                  /// Reason for Appointment (if available)
                  if (appointment.reason.isNotEmpty) ...[
                    _buildDetailRow(
                      context,
                      icon: Icons.notes_rounded,
                      title: 'Reason',
                      value: appointment.reason,
                      isDarkMode: isDarkMode,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                  ],

                  /// Payment Status
                  _buildPaymentRow(context, isDarkMode),
                ],
              ),
            ),

            /// Delete Button at bottom right
            if (onDelete != null)
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ArogyaSewaDeleteIconButton(
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 14,
            // color: ArogyaSewaColors.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(BuildContext context, bool isDarkMode) {
    final isFullyPaid = appointment.dueAmount <= 0;
    final paidColor = isFullyPaid ? Colors.green : Colors.amber;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? (isFullyPaid ? Colors.green.withValues(alpha: 0.2) : Colors.amber.withValues(alpha: 0.2))
            : (isFullyPaid
                ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.1)
                : ArogyaSewaColors.secondaryColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? (isFullyPaid ? Colors.green.withValues(alpha: 0.5) : Colors.amber.withValues(alpha: 0.5))
              : (isFullyPaid
                  ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.3)
                  : ArogyaSewaColors.secondaryColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isFullyPaid
                    ? Icons.check_circle_rounded
                    : Icons.payment_rounded,
                color: isDarkMode ? paidColor : (isFullyPaid
                    ? ArogyaSewaColors.primaryColor
                    : ArogyaSewaColors.secondaryColor),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isFullyPaid ? 'Paid' : 'Payment Pending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? paidColor : (isFullyPaid
                          ? ArogyaSewaColors.primaryColor
                          : ArogyaSewaColors.secondaryColor),
                    ),
              ),
            ],
          ),
          Text(
            'Rs. ${appointment.totalAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow(
    BuildContext context, {
    required DateTime dateTime,
    required bool isDarkMode,
  }) {
    final timeFormat = DateFormat('hh:mm a');
    final timeString = timeFormat.format(dateTime);

    return FutureBuilder<String?>(
      future: DateFormatter.convertAdToBsFull(dateTime.toIso8601String()),
      builder: (context, snapshot) {
        final nepaliDate = snapshot.data;
        final displayDate = nepaliDate ?? _formatDate(dateTime);
        
        return _buildDetailRow(
          context,
          icon: Icons.calendar_today_rounded,
          title: 'Date & Time',
          value: '$displayDate at $timeString',
          isDarkMode: isDarkMode,
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDarkMode) {
    final statusColor = _getStatusColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _getStatusText(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  // color: statusColor,
                ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (appointment.status) {
      case AppointmentStatusEnum.pendingPayment:
        return Colors.orange;
      case AppointmentStatusEnum.confirmed:
        return Colors.green;
      case AppointmentStatusEnum.inProgress:
        return Colors.blue;
      case AppointmentStatusEnum.completed:
        return ArogyaSewaColors.primaryColor;
      case AppointmentStatusEnum.cancelled:
        return Colors.red;
      case AppointmentStatusEnum.rescheduled:
        return Colors.purple;
    }
  }

  String _getStatusText() {
    switch (appointment.status) {
      case AppointmentStatusEnum.pendingPayment:
        return 'Pending Payment';
      case AppointmentStatusEnum.confirmed:
        return 'Confirmed';
      case AppointmentStatusEnum.inProgress:
        return 'In Progress';
      case AppointmentStatusEnum.completed:
        return 'Completed';
      case AppointmentStatusEnum.cancelled:
        return 'Cancelled';
      case AppointmentStatusEnum.rescheduled:
        return 'Rescheduled';
    }
  }

  String _formatDate(DateTime dateTime) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return dateFormat.format(dateTime);
  }
}
