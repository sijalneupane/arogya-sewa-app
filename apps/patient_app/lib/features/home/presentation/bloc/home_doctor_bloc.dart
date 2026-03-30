import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/doctors/domain/usecase/fetch_doctors_usecase.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_event.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_state.dart';

class HomeDoctorBloc extends Bloc<HomeDoctorEvent, HomeDoctorState> {
  final FetchDoctorsUsecase fetchDoctorsUsecase;

  HomeDoctorBloc({required this.fetchDoctorsUsecase})
    : super(const HomeDoctorInitial()) {
    on<FetchHomeDoctorEvent>(_onFetchDoctors);
    on<LoadMoreHomeDoctorEvent>(_onLoadMoreDoctors);
    on<RetryFetchHomeDoctorEvent>(_onRetryFetchDoctors);
  }

  Future<void> _onFetchDoctors(
    FetchHomeDoctorEvent event,
    Emitter<HomeDoctorState> emit,
  ) async {
    emit(const HomeDoctorLoading());

    final result = await fetchDoctorsUsecase.call(event.queryParams);

    result.fold((failure) => emit(HomeDoctorError(failure.message)), (
      doctorsResult,
    ) {
      final paginationMeta = doctorsResult.paginationMeta;
      emit(
        HomeDoctorLoaded(
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
    LoadMoreHomeDoctorEvent event,
    Emitter<HomeDoctorState> emit,
  ) async {
    if (state is HomeDoctorLoadingMore || state is HomeDoctorLoading) return;

    final currentState = state;
    if (currentState is HomeDoctorLoaded && currentState.hasReachedMax) return;
    if (currentState is! HomeDoctorLoaded) return;

    emit(HomeDoctorLoadingMore.fromLoaded(currentState));

    final result = await fetchDoctorsUsecase.call(event.queryParams);

    result.fold(
      (failure) {
        if (currentState is HomeDoctorLoaded) {
          emit(currentState);
        }
      },
      (doctorsResult) {
        if (currentState is HomeDoctorLoaded) {
          final paginationMeta = doctorsResult.paginationMeta;
          emit(
            HomeDoctorLoaded(
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
    RetryFetchHomeDoctorEvent event,
    Emitter<HomeDoctorState> emit,
  ) async {
    add(
      FetchHomeDoctorEvent(
        page: event.page,
        size: event.size,
        name: event.name,
        departmentName: event.departmentName,
        freeUpcomingOnly: event.freeUpcomingOnly,
      ),
    );
  }
}
