import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_core/utils/date_formatter.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/widgets/arogya_sewa_app_bar.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';
import 'package:shared_ui/widgets/arogya_sewa_textform_field.dart';
import 'package:shared_ui/widgets/dialogs/arogya_sewa_dialogs.dart';
import 'package:shared_ui/widgets/dialogs/arogya_sewa_loading_dialog.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_bloc.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_event.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_state.dart';

/// Appointment submission page
///
/// Allows users to enter reason and additional notes before booking
class AppointmentSubmissionPage extends StatefulWidget {
  final DoctorAvailabilityEntity availability;
  final String doctorName;

  const AppointmentSubmissionPage({
    super.key,
    required this.availability,
    required this.doctorName,
  });

  @override
  State<AppointmentSubmissionPage> createState() =>
      _AppointmentSubmissionPageState();
}

class _AppointmentSubmissionPageState
    extends State<AppointmentSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<CreateAppointmentBloc, CreateAppointmentState>(
      listener: (context, state) {
        if (state is CreateAppointmentLoading) {
          ArogyaSewaLoadingDialog.show(
            context: context,
            message: 'Booking your appointment...',
          );
        } else if (state is CreateAppointmentLoaded) {
          ArogyaSewaLoadingDialog.hide(context);
          ArogyaSewaDialogs.showSuccessDialog(
            context: context,
            title: 'Appointment Booked!',
            message: 'Your appointment has been successfully booked. You will receive a confirmation soon.',
            buttonText: 'Done',
          ).then((_) {
            if (context.mounted) {
              context.pop();
            }
          });
        } else if (state is CreateAppointmentError) {
          ArogyaSewaLoadingDialog.hide(context);
          ArogyaSewaDialogs.showErrorDialog(
            context: context,
            title: 'Booking Failed',
            message: state.message,
          );
        }
      },
      child: _buildScaffold(isDarkMode),
    );
  }

  Widget _buildScaffold(bool isDarkMode) {
    return Scaffold(
      appBar: ArogyaSewaAppBar.create(
        context: context,
        title: 'Book Appointment',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppointmentInfoCard(isDarkMode),
              const SizedBox(height: 24),
              _buildForm(isDarkMode),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(context, isDarkMode),
    );
  }

  Widget _buildAppointmentInfoCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDoctorInfoRow(isDarkMode),
          const SizedBox(height: 16),
          _buildDateTimeRow(
            icon: Icons.access_time_rounded,
            label: 'Start Time',
            dateTime: widget.availability.startDateTime,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildDateTimeRow(
            icon: Icons.schedule_rounded,
            label: 'End Time',
            dateTime: widget.availability.endDateTime,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfoRow(bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.person_rounded,
            size: 20,
            color: ArogyaSewaColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.6)
                          : ArogyaSewaColors.textColorGrey,
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.doctorName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite
                          : ArogyaSewaColors.textColorBlack,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeRow({
    required IconData icon,
    required String label,
    required DateTime dateTime,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 16,
            color: ArogyaSewaColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.6)
                          : ArogyaSewaColors.textColorGrey,
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 2),
              FutureBuilder<String?>(
                future: DateFormatter.convertAdToBsFull(
                  dateTime.toIso8601String(),
                ),
                builder: (context, snapshot) {
                  final nepaliDate = snapshot.data;
                  final timeString = DateFormatter.formatTime(
                    dateTime.toIso8601String(),
                  );
                  final displayDate = nepaliDate ??
                      DateFormatter.formatDateFull(dateTime.toIso8601String());
                  return Text(
                    '$displayDate at $timeString',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? ArogyaSewaColors.textColorWhite
                              : ArogyaSewaColors.textColorBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool isDarkMode) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReasonField(isDarkMode),
          const SizedBox(height: 20),
          _buildNotesField(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildReasonField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Appointment *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? ArogyaSewaColors.textColorWhite
                    : ArogyaSewaColors.textColorBlack,
              ),
        ),
        const SizedBox(height: 8),
        ArogyaSewaTextFormField(
          controller: _reasonController,
          hintText: 'e.g., Regular checkup, consultation, etc.',
          labelText: 'Reason',
          prefixIcon: const Icon(Icons.medical_services_rounded),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a reason';
            }
            if (value.trim().length < 5) {
              return 'Reason must be at least 5 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? ArogyaSewaColors.textColorWhite
                    : ArogyaSewaColors.textColorBlack,
              ),
        ),
        const SizedBox(height: 8),
        ArogyaSewaTextFormField(
          controller: _notesController,
          hintText: 'Any additional information you want to share...',
          labelText: 'Notes',
          prefixIcon: const Icon(Icons.notes_rounded),
          maxLines: 5,
          validator: (value) => null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.cardBackgroundColorDark
            : ArogyaSewaColors.cardBackgroundColorLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ArogyaSewaButton(
        onPressed: _handleSubmit,
        backgroundColor: ArogyaSewaColors.primaryColor,
        foregroundColor: ArogyaSewaColors.textColorWhite,
        child: const Text(
          'Submit Request',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    final reason = _reasonController.text.trim();
    final notes = _notesController.text.trim();

    ArogyaSewaDialogs.showConfirmDialog(
      context: context,
      title: 'Confirm Appointment',
      message:
          'Are you sure you want to book an appointment with ${widget.doctorName}?\n\nReason: $reason',
      icon: Icons.event_available_rounded,
      confirmText: 'Confirm Booking',
      cancelText: 'Cancel',
      onConfirm: () {
        Navigator.pop(context);
        _submitAppointment(reason, notes);
      },
    );
  }

  void _submitAppointment(String reason, String notes) {
    context.read<CreateAppointmentBloc>().add(
      SubmitCreateAppointmentEvent(
        availabilityId: widget.availability.availabilityId,
        reason: reason,
        notes: notes,
      ),
    );
  }
}
