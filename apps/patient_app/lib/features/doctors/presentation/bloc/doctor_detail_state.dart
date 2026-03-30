import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/doctor_detail_entity.dart';

abstract class DoctorDetailState extends Equatable {
  const DoctorDetailState();

  @override
  List<Object?> get props => [];
}

class DoctorDetailInitial extends DoctorDetailState {
  const DoctorDetailInitial();
}

class DoctorDetailLoading extends DoctorDetailState {
  const DoctorDetailLoading();
}

class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorDetailEntity doctor;

  const DoctorDetailLoaded({required this.doctor});

  @override
  List<Object?> get props => [doctor];
}

class DoctorDetailError extends DoctorDetailState {
  final String message;

  const DoctorDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
