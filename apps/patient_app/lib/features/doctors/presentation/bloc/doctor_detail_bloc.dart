import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/doctors/domain/usecase/fetch_doctor_detail_usecase.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_detail_event.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_detail_state.dart';

class DoctorDetailBloc extends Bloc<DoctorDetailEvent, DoctorDetailState> {
  final FetchDoctorDetailUsecase fetchDoctorDetailUsecase;

  DoctorDetailBloc({required this.fetchDoctorDetailUsecase})
    : super(const DoctorDetailInitial()) {
    on<FetchDoctorDetailEvent>(_onFetchDoctorDetail);
    on<RetryFetchDoctorDetailEvent>(_onRetryFetchDoctorDetail);
  }

  Future<void> _onFetchDoctorDetail(
    FetchDoctorDetailEvent event,
    Emitter<DoctorDetailState> emit,
  ) async {
    emit(const DoctorDetailLoading());

    final result = await fetchDoctorDetailUsecase.call(event.doctorId);

    result.fold(
      (failure) => emit(DoctorDetailError(failure.message)),
      (doctor) => emit(DoctorDetailLoaded(doctor: doctor)),
    );
  }

  Future<void> _onRetryFetchDoctorDetail(
    RetryFetchDoctorDetailEvent event,
    Emitter<DoctorDetailState> emit,
  ) async {
    add(FetchDoctorDetailEvent(doctorId: event.doctorId));
  }
}
