import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_event.dart';
import 'package:patient_app/features/appointments/presentation/bloc/create_appointment_state.dart';
import 'package:shared_feature/appointments/domain/entities/create_appointment_entity.dart';
import 'package:shared_feature/appointments/domain/usecase/create_appointment_usecase.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  final CreateAppointmentUsecase createAppointmentUsecase;

  CreateAppointmentBloc({
    required this.createAppointmentUsecase,
  }) : super(const CreateAppointmentInitial()) {
    on<SubmitCreateAppointmentEvent>(_onSubmitCreateAppointment);
    on<RetryCreateAppointmentEvent>(_onRetryCreateAppointment);
    on<ResetCreateAppointmentEvent>(_onResetCreateAppointment);
  }

  Future<void> _onSubmitCreateAppointment(
    SubmitCreateAppointmentEvent event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    emit(const CreateAppointmentLoading());

    final result = await createAppointmentUsecase.call(
      CreateAppointmentEntity(
        availabilityId: event.availabilityId,
        reason: event.reason,
        notes: event.notes,
      ),
    );

    result.fold(
      (failure) => emit(CreateAppointmentError(failure.message)),
      (appointment) => emit(CreateAppointmentLoaded(appointment)),
    );
  }

  Future<void> _onRetryCreateAppointment(
    RetryCreateAppointmentEvent event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    add(SubmitCreateAppointmentEvent(
      availabilityId: event.availabilityId,
      reason: event.reason,
      notes: event.notes,
    ));
  }

  Future<void> _onResetCreateAppointment(
    ResetCreateAppointmentEvent event,
    Emitter<CreateAppointmentState> emit,
  ) async {
    emit(const CreateAppointmentInitial());
  }
}
