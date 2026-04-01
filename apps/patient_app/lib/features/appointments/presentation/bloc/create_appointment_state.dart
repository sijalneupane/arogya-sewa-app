import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';

abstract class CreateAppointmentState extends Equatable {
  const CreateAppointmentState();

  @override
  List<Object?> get props => [];
}

class CreateAppointmentInitial extends CreateAppointmentState {
  const CreateAppointmentInitial();
}

class CreateAppointmentLoading extends CreateAppointmentState {
  const CreateAppointmentLoading();
}

class CreateAppointmentLoaded extends CreateAppointmentState {
  final AppointmentEntity appointment;

  const CreateAppointmentLoaded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class CreateAppointmentError extends CreateAppointmentState {
  final String message;

  const CreateAppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
