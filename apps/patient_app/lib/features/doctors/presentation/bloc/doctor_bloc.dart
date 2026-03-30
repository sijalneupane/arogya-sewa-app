import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/doctors/domain/usecase/fetch_doctors_usecase.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_event.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final FetchDoctorsUsecase fetchDoctorsUsecase;

  DoctorBloc({required this.fetchDoctorsUsecase})
    : super(const DoctorInitial()) {
    on<FetchDoctorEvent>(_onFetchDoctors);
    on<LoadMoreDoctorEvent>(_onLoadMoreDoctors);
    on<RetryFetchDoctorEvent>(_onRetryFetchDoctors);
  }

  Future<void> _onFetchDoctors(
    FetchDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    emit(const DoctorLoading());

    final result = await fetchDoctorsUsecase.call(event.queryParams);

    result.fold((failure) => emit(DoctorError(failure.message)), (
      doctorsResult,
    ) {
      final paginationMeta = doctorsResult.paginationMeta;
      emit(
        DoctorLoaded(
          doctors: doctorsResult.doctors,
          currentPage: paginationMeta.currentPage,
          totalPage: paginationMeta.totalPage,
          totalRecords: paginationMeta.totalRecords,
          hasReachedMax: paginationMeta.currentPage >= paginationMeta.totalPage,
        ),
      );
    });
  }

  Future<void> _onLoadMoreDoctors(
    LoadMoreDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    if (state is DoctorLoadingMore || state is DoctorLoading) return;

    final currentState = state;
    if (currentState is DoctorLoaded && currentState.hasReachedMax) return;
    if (currentState is! DoctorLoaded) return;

    emit(DoctorLoadingMore.fromLoaded(currentState));

    final result = await fetchDoctorsUsecase.call(event.queryParams);

    result.fold(
      (failure) {
        if (currentState is DoctorLoaded) {
          emit(currentState);
        }
      },
      (doctorsResult) {
        if (currentState is DoctorLoaded) {
          final paginationMeta = doctorsResult.paginationMeta;
          emit(
            DoctorLoaded(
              doctors: [...currentState.doctors, ...doctorsResult.doctors],
              currentPage: paginationMeta.currentPage,
              totalPage: paginationMeta.totalPage,
              totalRecords: paginationMeta.totalRecords,
              hasReachedMax:
                  paginationMeta.currentPage >= paginationMeta.totalPage,
            ),
          );
        }
      },
    );
  }

  Future<void> _onRetryFetchDoctors(
    RetryFetchDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    add(
      FetchDoctorEvent(
        page: event.page,
        size: event.size,
        name: event.name,
        departmentName: event.departmentName,
        freeUpcomingOnly: event.freeUpcomingOnly,
        status: event.status,
      ),
    );
  }
}
