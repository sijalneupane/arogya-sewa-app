import 'package:equatable/equatable.dart';

abstract class CreateAppointmentEvent extends Equatable {
  const CreateAppointmentEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCreateAppointmentEvent extends CreateAppointmentEvent {
  final String availabilityId;
  final String reason;
  final String notes;

  const SubmitCreateAppointmentEvent({
    required this.availabilityId,
    required this.reason,
    required this.notes,
  });

  @override
  List<Object?> get props => [availabilityId, reason, notes];
}

class RetryCreateAppointmentEvent extends CreateAppointmentEvent {
  final String availabilityId;
  final String reason;
  final String notes;

  const RetryCreateAppointmentEvent({
    required this.availabilityId,
    required this.reason,
    required this.notes,
  });

  @override
  List<Object?> get props => [availabilityId, reason, notes];
}

class ResetCreateAppointmentEvent extends CreateAppointmentEvent {
  const ResetCreateAppointmentEvent();
}
