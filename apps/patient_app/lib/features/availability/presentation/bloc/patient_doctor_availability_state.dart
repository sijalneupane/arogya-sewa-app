import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';

abstract class PatientDoctorAvailabilityState extends Equatable {
  const PatientDoctorAvailabilityState();

  @override
  List<Object?> get props => [];
}

class PatientDoctorAvailabilityInitial extends PatientDoctorAvailabilityState {
  const PatientDoctorAvailabilityInitial();
}

class PatientDoctorAvailabilityLoading extends PatientDoctorAvailabilityState {
  const PatientDoctorAvailabilityLoading();
}

class PatientDoctorAvailabilityLoaded extends PatientDoctorAvailabilityState {
  final List<DoctorAvailabilityEntity> availabilities;
  final int currentPage;
  final int totalPage;
  final bool hasReachedMax;

  const PatientDoctorAvailabilityLoaded({
    required this.availabilities,
    required this.currentPage,
    required this.totalPage,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [availabilities, currentPage, totalPage, hasReachedMax];
}

class PatientDoctorAvailabilityError extends PatientDoctorAvailabilityState {
  final String message;

  const PatientDoctorAvailabilityError(this.message);

  @override
  List<Object?> get props => [message];
}
