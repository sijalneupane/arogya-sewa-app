import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/home/domain/usecase/fetch_doctors_usecase.dart';
import 'package:patient_app/features/home/presentation/bloc/doctors_event.dart';
import 'package:patient_app/features/home/presentation/bloc/doctors_state.dart';

/// BLoC for managing doctors state
class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final FetchDoctorsUsecase fetchDoctorsUsecase;

  DoctorsBloc({required this.fetchDoctorsUsecase})
    : super(const DoctorsInitial()) {
    on<FetchDoctorsEvent>(_onFetchDoctors);
    on<LoadMoreDoctorsEvent>(_onLoadMoreDoctors);
    on<RetryFetchDoctorsEvent>(_onRetryFetchDoctors);
  }

  /// Handle fetch doctors event
  Future<void> _onFetchDoctors(
    FetchDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    emit(const DoctorsLoading());

    final result = await fetchDoctorsUsecase.call(event.params);

    result.fold((failure) => emit(DoctorsError(failure.message)), (
      doctorsResult,
    ) {
      final paginationMeta = doctorsResult.paginationMeta;
      emit(
        DoctorsLoaded(
          doctors: doctorsResult.doctors,
          currentPage: paginationMeta.currentPage,
          totalPage: paginationMeta.totalPage,
          totalRecords: paginationMeta.totalRecords,
          hasReachedMax: paginationMeta.currentPage >= paginationMeta.totalPage,
        ),
      );
    });
  }

  /// Handle load more doctors event (pagination)
  Future<void> _onLoadMoreDoctors(
    LoadMoreDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    // Don't load more if already loading or reached max
    if (state is DoctorsLoadingMore || state is DoctorsLoading) return;

    final currentState = state;
    if (currentState is DoctorsLoaded && currentState.hasReachedMax) return;

    emit(const DoctorsLoadingMore());

    final result = await fetchDoctorsUsecase.call(event.params);

    result.fold(
      (failure) {
        // Keep existing data and show error in UI if needed
        if (currentState is DoctorsLoaded) {
          emit(currentState);
        }
      },
      (doctorsResult) {
        if (currentState is DoctorsLoaded) {
          final paginationMeta = doctorsResult.paginationMeta;

          // Append new doctors to existing list
          final updatedDoctors = [
            ...currentState.doctors,
            ...doctorsResult.doctors,
          ];

          emit(
            DoctorsLoaded(
              doctors: updatedDoctors,
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

  /// Handle retry fetch doctors event
  Future<void> _onRetryFetchDoctors(
    RetryFetchDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    // Re-trigger fetch doctors
    add(
      FetchDoctorsEvent(
        name: event.name,
        departmentId: event.departmentId,
        freeUpcomingOnly: event.freeUpcomingOnly,
      ),
    );
  }
}
