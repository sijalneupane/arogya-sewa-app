import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/utils/date_formatter.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_ui/widgets/arogya_sewa_app_bar.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';
import 'package:shared_ui/widgets/arogya_sewa_textform_field.dart';
import 'package:shared_ui/widgets/dialogs/arogya_sewa_dialogs.dart';
import 'package:shared_ui/widgets/dialogs/arogya_sewa_loading_dialog.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_bloc.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_event.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_state.dart';
import 'package:patient_app/features/payments/presentation/bloc/khalti_payment_bloc.dart';
import 'package:patient_app/features/payments/presentation/bloc/khalti_payment_event.dart';
import 'package:patient_app/features/payments/presentation/bloc/khalti_payment_state.dart';
import 'package:patient_app/core/config/khalti_checkout_config.dart';
import 'package:patient_app/core/services/patient_khalti_checkout_service.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';

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
  String? _createdAppointmentId;
  double? _appointmentAmount;
  String? _userPhone;

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider<KhaltiPaymentBloc>(
          create: (_) => GetIt.instance<KhaltiPaymentBloc>(),
        ),
      ],
      child: Builder(
        builder: (pageContext) => BlocListener<CreateAppointmentBloc, CreateAppointmentState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _onCreateAppointmentStateChange(pageContext, state);
            });
          },
          child: BlocListener<KhaltiPaymentBloc, KhaltiPaymentState>(
            listener: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _onKhaltiPaymentStateChange(pageContext, state);
              });
            },
            child: _buildScaffold(pageContext, isDarkMode),
          ),
        ),
      ),
    );
  }

  void _onCreateAppointmentStateChange(
    BuildContext context,
    CreateAppointmentState state,
  ) {
    if (state is CreateAppointmentLoading) {
      ArogyaSewaLoadingDialog.show(
        context: context,
        message: 'Creating appointment...',
      );
    } else if (state is CreateAppointmentLoaded) {
      ArogyaSewaLoadingDialog.hide(context);
      // Store appointment details
      setState(() {
        _createdAppointmentId = state.appointment.appointmentId;
        _appointmentAmount = state.appointment.advanceFee;
        _userPhone = state.appointment.patient.user.phoneNumber;
      });
      // Initiate Khalti payment
      _initiateKhaltiPayment(context);
    } else if (state is CreateAppointmentError) {
      ArogyaSewaLoadingDialog.hide(context);
      _showErrorBottomSheet(context, state.message);
    }
  }

  void _onKhaltiPaymentStateChange(
    BuildContext context,
    KhaltiPaymentState state,
  ) {
    if (state is KhaltiPaymentLoading) {
      ArogyaSewaLoadingDialog.show(
        context: context,
        message: 'Initiating payment...',
      );
    } else if (state is KhaltiPaymentInitiated) {
      ArogyaSewaLoadingDialog.hide(context);
      // Open Khalti SDK
      _openKhaltiSDK(context, state.pidx);
    } else if (state is KhaltiPaymentVerifying) {
      ArogyaSewaLoadingDialog.show(
        context: context,
        message: 'Verifying payment...',
      );
    } else if (state is KhaltiPaymentVerified) {
      ArogyaSewaLoadingDialog.hide(context);
      ArogyaSewaDialogs.showSuccessDialog(
        context: context,
        title: 'Payment Successful!',
        message:
            'Your appointment has been confirmed. You will receive a confirmation SMS/email.',
        buttonText: 'Done',
      ).then((_) {
        if (mounted) {
          context.pop();
        }
      });
    } else if (state is KhaltiPaymentFailure) {
      ArogyaSewaLoadingDialog.hide(context);
      _showErrorBottomSheet(context, state.message);
    }
  }

  Widget _buildScaffold(BuildContext pageContext, bool isDarkMode) {
    return Scaffold(
      appBar: ArogyaSewaAppBar.create(
        context: pageContext,
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
      bottomNavigationBar: _buildSubmitButton(pageContext, isDarkMode),
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

  Widget _buildSubmitButton(BuildContext pageContext, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(pageContext).padding.bottom,
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
        onPressed: () => _handleSubmit(pageContext),
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

  void _handleSubmit(BuildContext pageContext) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    HideKeyboard.hide(pageContext);
    _submitAppointment(pageContext);
  }

  void _submitAppointment(BuildContext pageContext) {
    final reason = _reasonController.text.trim();
    final notes = _notesController.text.trim();

    pageContext.read<CreateAppointmentBloc>().add(
      SubmitCreateAppointmentEvent(
        availabilityId: widget.availability.availabilityId,
        reason: reason,
        notes: notes,
      ),
    );
  }

  void _initiateKhaltiPayment(BuildContext pageContext) {
    if (_createdAppointmentId == null || _appointmentAmount == null) {
      _showErrorBottomSheet(
        pageContext,
        'Failed to initiate payment. Please try again.',
      );
      return;
    }

    if (_userPhone == null || _userPhone!.isEmpty) {
      _showErrorBottomSheet(
        pageContext,
        'Phone number not found. Please update your profile.',
      );
      return;
    }

    // Initiate payment through BLoC
    pageContext.read<KhaltiPaymentBloc>().add(
      InitiateKhaltiPaymentEvent(
        appointmentId: _createdAppointmentId!,
        amount: (_appointmentAmount! * 100).toInt(), // Convert to paisa
        customerPhone: _userPhone!,
      ),
    );
  }

  Future<void> _openKhaltiSDK(BuildContext pageContext, String pidx) async {
    if (_appointmentAmount == null) {
      _showErrorBottomSheet(
        pageContext,
        'Payment amount is missing. Please try again.',
      );
      return;
    }

    try {
      log('Opening Khalti SDK via global service');

      // Use global Khalti service to open checkout
      await GetIt.instance<PatientKhaltiCheckoutService>().openCheckout(
        context: pageContext,
        pidx: pidx,
        enableDebugging: KhaltiCheckoutConfig.enableDebugLogs,
        onPaymentResult: (paymentResult, khalti) {
          log('Khalti payment success: ${paymentResult.payload}');
          if (mounted) {
            khalti.close(pageContext);
          }
          if (!mounted) return;

          final resolvedPidx = paymentResult.payload?.pidx ?? pidx;
          _verifyKhaltiPayment(pageContext, resolvedPidx);
        },
        onMessage: (
          khalti, {
          description,
          statusCode,
          event,
          needsPaymentConfirmation,
        }) async {
          log(
            'Khalti message: description=$description, statusCode=$statusCode, event=$event, needsPaymentConfirmation=$needsPaymentConfirmation',
          );

          if (needsPaymentConfirmation == true) {
            await khalti.verify();
            return;
          }

          if (!mounted) return;
          khalti.close(pageContext);
          final errorMessage = description?.toString();
          _showErrorBottomSheet(
            pageContext,
            (errorMessage == null || errorMessage.isEmpty)
                ? 'Payment failed or was canceled. Please try again.'
                : errorMessage,
          );
        },
        onReturn: () {
          log('Khalti return_url loaded successfully.');
        },
      );
    } catch (e) {
      log('Error opening Khalti SDK: $e');
      if (!mounted) return;
      _showErrorBottomSheet(
        pageContext,
        'Unable to open Khalti checkout. Please try again.',
      );
    }
  }

  void _verifyKhaltiPayment(BuildContext pageContext, String pidx) {
    if (_createdAppointmentId == null || _createdAppointmentId!.isEmpty) {
      _showErrorBottomSheet(
        pageContext,
        'Appointment id is missing. Please contact support.',
      );
      return;
    }

    pageContext.read<KhaltiPaymentBloc>().add(
      VerifyKhaltiPaymentEvent(
        appointmentId: _createdAppointmentId!,
        pidx: pidx,
      ),
    );
  }

  void _showErrorBottomSheet(BuildContext pageContext, String message) {
    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ArogyaSewaErrorBottomSheet(
        title: 'Booking Failed',
        message: message,
        onRetry: () {
         context.pop();
          _submitAppointment(pageContext);
        },
        onClose: () {
         context.pop();
        },
      ),
    );
  }
}

/// Error bottom sheet widget
class ArogyaSewaErrorBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback onClose;

  const ArogyaSewaErrorBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.cardBackgroundColorDark
            : ArogyaSewaColors.cardBackgroundColorLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Error icon
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                ),
          ),
          const SizedBox(height: 8),
          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                      : ArogyaSewaColors.textColorGrey,
                ),
          ),
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              if (onRetry != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRetry,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(
                        color: ArogyaSewaColors.primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: ArogyaSewaColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (onRetry != null) const SizedBox(width: 12),
              Expanded(
                child: ArogyaSewaButton(
                  onPressed: onClose,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
