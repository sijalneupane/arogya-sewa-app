import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_event.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_state.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';
import 'package:shared_feature/appointments/domain/entities/fetch_my_appointments_query_entity.dart';
import 'package:shared_feature/appointments/domain/usecase/fetch_my_appointments_usecase.dart';

class PatientAppointmentBloc
    extends Bloc<PatientAppointmentEvent, PatientAppointmentState> {
  final FetchMyAppointmentsUsecase fetchMyAppointmentsUsecase;

  // Store current filter state to prevent re-hitting API on navigation
  AppointmentStatusEnum? _currentStatus;
  DateTime? _currentDateFrom;
  DateTime? _currentDateTo;
  int _currentPageSize = 10;

  // Track user session to clear data on logout
  String? _lastUserId;

  PatientAppointmentBloc({
    required this.fetchMyAppointmentsUsecase,
  }) : super(const PatientAppointmentInitial()) {
    on<FetchPatientAppointmentsEvent>(_onFetchAppointments);
    on<LoadMorePatientAppointmentsEvent>(_onLoadMoreAppointments);
    on<RefreshPatientAppointmentsEvent>(_onRefreshAppointments);
    on<RetryFetchPatientAppointmentsEvent>(_onRetryFetchAppointments);
    on<FilterPatientAppointmentsEvent>(_onFilterAppointments);
    on<ClearFiltersPatientAppointmentsEvent>(_onClearFilters);
  }

  /// Check if user session has changed (logout/login)
  bool _isUserSessionChanged(String? currentUserId) {
    if (_lastUserId == null) return false;
    return _lastUserId != currentUserId;
  }

  /// Update last user ID
  void updateUserId(String? userId) {
    if (_isUserSessionChanged(userId)) {
      // User changed - clear state and force refresh
      _lastUserId = userId;
      _currentStatus = null;
      _currentDateFrom = null;
      _currentDateTo = null;
      emit(const PatientAppointmentInitial());
    } else {
      _lastUserId = userId;
    }
  }

  Future<void> _onFetchAppointments(
    FetchPatientAppointmentsEvent event,
    Emitter<PatientAppointmentState> emit,
  ) async {
    // Don't fetch if already loading
    if (state is PatientAppointmentLoading) return;

    emit(const PatientAppointmentLoading());

    // Update current filters
    _currentStatus = event.status;
    _currentDateFrom = event.dateFrom;
    _currentDateTo = event.dateTo;
    _currentPageSize = event.size;

    final query = FetchMyAppointmentsQueryEntity(
      status: event.status,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      page: event.page,
      size: event.size,
    );

    final result = await fetchMyAppointmentsUsecase.call(query);

    result.fold(
      (failure) => emit(PatientAppointmentError(failure.message)),
      (appointmentList) {
        final paginationMeta = appointmentList.paginationMeta;
        emit(
          PatientAppointmentLoaded(
            appointments: appointmentList.appointments,
            currentPage: paginationMeta.currentPage,
            totalPage: paginationMeta.totalPage,
            totalRecords: paginationMeta.totalRecords,
            hasReachedMax: paginationMeta.currentPage >= paginationMeta.totalPage,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreAppointments(
    LoadMorePatientAppointmentsEvent event,
    Emitter<PatientAppointmentState> emit,
  ) async {
    // Prevent multiple load more requests
    if (state is PatientAppointmentLoadingMore ||
        state is PatientAppointmentLoading) {
      return;
    }

    final currentState = state;
    if (currentState is! PatientAppointmentLoaded) return;
    if (currentState.hasReachedMax) return;

    emit(PatientAppointmentLoadingMore.fromLoaded(currentState));

    final query = FetchMyAppointmentsQueryEntity(
      status: _currentStatus,
      dateFrom: _currentDateFrom,
      dateTo: _currentDateTo,
      page: event.currentPage,
      size: event.size,
    );

    final result = await fetchMyAppointmentsUsecase.call(query);

    result.fold(
      (failure) {
        // On error, revert to previous state
        emit(currentState);
      },
      (appointmentList) {
        final paginationMeta = appointmentList.paginationMeta;
        emit(
          currentState.copyWith(
            appointments: [
              ...currentState.appointments,
              ...appointmentList.appointments,
            ],
            currentPage: paginationMeta.currentPage,
            totalPage: paginationMeta.totalPage,
            totalRecords: paginationMeta.totalRecords,
            hasReachedMax:
                paginationMeta.currentPage >= paginationMeta.totalPage,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshAppointments(
    RefreshPatientAppointmentsEvent event,
    Emitter<PatientAppointmentState> emit,
  ) async {
    // Always hit API on refresh, even for same user
    final currentState = state;
    if (currentState is! PatientAppointmentLoaded) {
      // If not loaded yet, do a normal fetch
      add(
        FetchPatientAppointmentsEvent(
          page: event.page,
          size: event.size,
          status: event.status,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
        ),
      );
      return;
    }

    // Emit refreshing state
    emit(PatientAppointmentRefreshing.fromLoaded(currentState));

    // Update current filters
    _currentStatus = event.status;
    _currentDateFrom = event.dateFrom;
    _currentDateTo = event.dateTo;
    _currentPageSize = event.size;

    final query = FetchMyAppointmentsQueryEntity(
      status: event.status,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      page: event.page,
      size: event.size,
    );

    final result = await fetchMyAppointmentsUsecase.call(query);

    result.fold(
      (failure) {
        // On error, revert to previous state
        emit(currentState);
      },
      (appointmentList) {
        final paginationMeta = appointmentList.paginationMeta;
        emit(
          PatientAppointmentLoaded(
            appointments: appointmentList.appointments,
            currentPage: paginationMeta.currentPage,
            totalPage: paginationMeta.totalPage,
            totalRecords: paginationMeta.totalRecords,
            hasReachedMax:
                paginationMeta.currentPage >= paginationMeta.totalPage,
          ),
        );
      },
    );
  }

  Future<void> _onRetryFetchAppointments(
    RetryFetchPatientAppointmentsEvent event,
    Emitter<PatientAppointmentState> emit,
  ) async {
    add(
      FetchPatientAppointmentsEvent(
        page: event.page,
        size: event.size,
        status: event.status,
        dateFrom: event.dateFrom,
        dateTo: event.dateTo,
      ),
    );
  }

  Future<void> _onFilterAppointments(
    FilterPatientAppointmentsEvent event,
    Emitter<PatientAppointmentState> emit,
  ) async {
    // Update filters and fetch from page 1
    add(
      FetchPatientAppointmentsEvent(
        page: 1,
        size: _currentPageSize,
        status: event.status,
        dateFrom: event.dateFrom,
        dateTo: event.dateTo,
      ),
    );
  }

  Future<void> _onClearFilters(
    ClearFiltersPatientAppointmentsEvent event,
    Emitter<PatientAppointmentState> emit,
  ) async {
    // Clear all filters and fetch
    _currentStatus = null;
    _currentDateFrom = null;
    _currentDateTo = null;

    add(
      FetchPatientAppointmentsEvent(
        page: 1,
        size: _currentPageSize,
      ),
    );
  }

  /// Get current filter values
  AppointmentStatusEnum? get currentStatus => _currentStatus;
  DateTime? get currentDateFrom => _currentDateFrom;
  DateTime? get currentDateTo => _currentDateTo;
}
