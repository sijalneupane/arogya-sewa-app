import 'package:equatable/equatable.dart';

abstract class DoctorDetailEvent extends Equatable {
  const DoctorDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorDetailEvent extends DoctorDetailEvent {
  final String doctorId;

  const FetchDoctorDetailEvent({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

class RetryFetchDoctorDetailEvent extends DoctorDetailEvent {
  final String doctorId;

  const RetryFetchDoctorDetailEvent({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}
