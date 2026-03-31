import 'package:equatable/equatable.dart';

abstract class PatientDoctorAvailabilityEvent extends Equatable {
  const PatientDoctorAvailabilityEvent();

  @override
  List<Object?> get props => [];
}

class FetchPatientDoctorAvailabilityEvent extends PatientDoctorAvailabilityEvent {
  final String doctorId;
  final bool? isBooked;
  final bool? futureOnly;
  final int page;
  final int size;

  const FetchPatientDoctorAvailabilityEvent({
    required this.doctorId,
    this.isBooked,
    this.futureOnly = true,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [doctorId, isBooked, futureOnly, page, size];
}

class RetryFetchPatientDoctorAvailabilityEvent extends PatientDoctorAvailabilityEvent {
  final String doctorId;
  final bool? isBooked;
  final bool? futureOnly;
  final int page;
  final int size;

  const RetryFetchPatientDoctorAvailabilityEvent({
    required this.doctorId,
    this.isBooked,
    this.futureOnly = true,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [doctorId, isBooked, futureOnly, page, size];
}
