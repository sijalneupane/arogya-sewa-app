import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/availability/domain/usecases/fetch_doctor_availabilities_usecase.dart';
import 'package:patient_app/features/availability/presentation/bloc/patient_doctor_availability_event.dart';
import 'package:patient_app/features/availability/presentation/bloc/patient_doctor_availability_state.dart';
import 'package:shared_core/domain/entities/availability_query_params_entity.dart';

class PatientDoctorAvailabilityBloc
    extends Bloc<PatientDoctorAvailabilityEvent, PatientDoctorAvailabilityState> {
  final FetchDoctorAvailabilitiesUsecase fetchDoctorAvailabilitiesUsecase;

  PatientDoctorAvailabilityBloc({
    required this.fetchDoctorAvailabilitiesUsecase,
  }) : super(const PatientDoctorAvailabilityInitial()) {
    on<FetchPatientDoctorAvailabilityEvent>(_onFetchDoctorAvailability);
    on<RetryFetchPatientDoctorAvailabilityEvent>(_onRetryFetchDoctorAvailability);
  }

  Future<void> _onFetchDoctorAvailability(
    FetchPatientDoctorAvailabilityEvent event,
    Emitter<PatientDoctorAvailabilityState> emit,
  ) async {
    emit(const PatientDoctorAvailabilityLoading());

    final result = await fetchDoctorAvailabilitiesUsecase.call(
      AvailabilityQueryParamsEntity(
        doctorId: event.doctorId,
        isBooked: event.isBooked,
        futureOnly: event.futureOnly,
        page: event.page,
        size: event.size,
      ),
    );

    result.fold(
      (failure) => emit(PatientDoctorAvailabilityError(failure.message)),
      (availabilityResult) {
        final paginationMeta = availabilityResult.paginationMeta;
        emit(
          PatientDoctorAvailabilityLoaded(
            availabilities: availabilityResult.availabilities,
            currentPage: paginationMeta.currentPage,
            totalPage: paginationMeta.totalPage,
            hasReachedMax: paginationMeta.currentPage >= paginationMeta.totalPage,
          ),
        );
      },
    );
  }

  Future<void> _onRetryFetchDoctorAvailability(
    RetryFetchPatientDoctorAvailabilityEvent event,
    Emitter<PatientDoctorAvailabilityState> emit,
  ) async {
    add(
      FetchPatientDoctorAvailabilityEvent(
        doctorId: event.doctorId,
        isBooked: event.isBooked,
        futureOnly: event.futureOnly,
        page: event.page,
        size: event.size,
      ),
    );
  }
}
