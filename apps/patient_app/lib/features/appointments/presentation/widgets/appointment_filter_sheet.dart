import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_bloc.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_event.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

class AppointmentFilterSheet extends StatefulWidget {
  final AppointmentStatusEnum? currentStatus;
  final DateTime? currentDateFrom;
  final DateTime? currentDateTo;

  const AppointmentFilterSheet({
    super.key,
    this.currentStatus,
    this.currentDateFrom,
    this.currentDateTo,
  });

  @override
  State<AppointmentFilterSheet> createState() => _AppointmentFilterSheetState();
}

class _AppointmentFilterSheetState extends State<AppointmentFilterSheet> {
  AppointmentStatusEnum? _selectedStatus;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
    _dateFrom = widget.currentDateFrom;
    _dateTo = widget.currentDateTo;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final sheetBgColor = isDarkMode
        ? ArogyaSewaColors.cardBackgroundColorDark
        : ArogyaSewaColors.cardBackgroundColorLight;
    final textColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite
        : ArogyaSewaColors.textColorBlack;
    final mutedTextColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
        : ArogyaSewaColors.textColorGrey;

    return Container(
      decoration: BoxDecoration(
        color: sheetBgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Appointments',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                IconButton(
                  onPressed: () =>context.pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: mutedTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Status Filter
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip(
                  context,
                  label: 'All',
                  value: null,
                  isDarkMode: isDarkMode,
                ),
                _buildFilterChip(
                  context,
                  label: 'Pending Payment',
                  value: AppointmentStatusEnum.pendingPayment,
                  isDarkMode: isDarkMode,
                ),
                _buildFilterChip(
                  context,
                  label: 'Confirmed',
                  value: AppointmentStatusEnum.confirmed,
                  isDarkMode: isDarkMode,
                ),
                _buildFilterChip(
                  context,
                  label: 'In Progress',
                  value: AppointmentStatusEnum.inProgress,
                  isDarkMode: isDarkMode,
                ),
                _buildFilterChip(
                  context,
                  label: 'Completed',
                  value: AppointmentStatusEnum.completed,
                  isDarkMode: isDarkMode,
                ),
                _buildFilterChip(
                  context,
                  label: 'Cancelled',
                  value: AppointmentStatusEnum.cancelled,
                  isDarkMode: isDarkMode,
                ),
                _buildFilterChip(
                  context,
                  label: 'Rescheduled',
                  value: AppointmentStatusEnum.rescheduled,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Date Range Filter
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    context,
                    label: 'From',
                    selectedDate: _dateFrom,
                    onTap: () => _selectDate(context, isFrom: true),
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDatePicker(
                    context,
                    label: 'To',
                    selectedDate: _dateTo,
                    onTap: () => _selectDate(context, isFrom: false),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Clear Filters Button
            if (_selectedStatus != null || _dateFrom != null || _dateTo != null)
              GestureDetector(
                onTap: _clearFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.clear_all_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Clear All Filters',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            /// Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ArogyaSewaColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply Filters',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required AppointmentStatusEnum? value,
    required bool isDarkMode,
  }) {
    final isSelected = _selectedStatus == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = isSelected ? null : value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? ArogyaSewaColors.primaryColor
              : isDarkMode
                  ? ArogyaSewaColors.shimmerBaseDark
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? ArogyaSewaColors.primaryColor
                : isDarkMode
                    ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.3)
                    : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : isDarkMode
                        ? ArogyaSewaColors.textColorWhite
                        : ArogyaSewaColors.textColorBlack,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    final mutedTextColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
        : ArogyaSewaColors.textColorGrey;
    final textColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite
        : ArogyaSewaColors.textColorBlack;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ArogyaSewaColors.shimmerBaseDark
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.3)
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: mutedTextColor,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: ArogyaSewaColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(selectedDate)
                        : 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selectedDate != null
                              ? textColor
                              : mutedTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isFrom,
  }) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_dateFrom ?? DateTime.now()) : (_dateTo ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ArogyaSewaColors.primaryColor,
              onPrimary: Colors.white,
              surface: isDarkMode ? ArogyaSewaColors.cardBackgroundColorDark : Colors.white,
              onSurface: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
          // If to date is before from date, set to date same as from date
          if (_dateTo != null && _dateTo!.isBefore(picked)) {
            _dateTo = picked;
          }
        } else {
          _dateTo = picked;
          // If from date is after to date, set from date same as to date
          if (_dateFrom != null && _dateFrom!.isAfter(picked)) {
            _dateFrom = picked;
          }
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _dateFrom = null;
      _dateTo = null;
    });
  }

  void _applyFilters() {
    context.read<PatientAppointmentBloc>().add(
          FilterPatientAppointmentsEvent(
            status: _selectedStatus,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
          ),
        );
   context.pop();
  }
}
