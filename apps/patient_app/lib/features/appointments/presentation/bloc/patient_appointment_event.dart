import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';

abstract class PatientAppointmentEvent extends Equatable {
  const PatientAppointmentEvent();

  @override
  List<Object?> get props => [];
}

/// Initial fetch event - loads first page
class FetchPatientAppointmentsEvent extends PatientAppointmentEvent {
  final int page;
  final int size;
  final AppointmentStatusEnum? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const FetchPatientAppointmentsEvent({
    this.page = 1,
    this.size = 10,
    this.status,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [page, size, status, dateFrom, dateTo];
}

/// Load more event for pagination
class LoadMorePatientAppointmentsEvent extends PatientAppointmentEvent {
  final int currentPage;
  final int size;
  final AppointmentStatusEnum? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const LoadMorePatientAppointmentsEvent({
    required this.currentPage,
    this.size = 10,
    this.status,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [currentPage, size, status, dateFrom, dateTo];
}

/// Pull to refresh event - always hits API
class RefreshPatientAppointmentsEvent extends PatientAppointmentEvent {
  final int page;
  final int size;
  final AppointmentStatusEnum? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const RefreshPatientAppointmentsEvent({
    this.page = 1,
    this.size = 10,
    this.status,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [page, size, status, dateFrom, dateTo];
}

/// Retry event on error
class RetryFetchPatientAppointmentsEvent extends PatientAppointmentEvent {
  final int page;
  final int size;
  final AppointmentStatusEnum? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const RetryFetchPatientAppointmentsEvent({
    this.page = 1,
    this.size = 10,
    this.status,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [page, size, status, dateFrom, dateTo];
}

/// Filter changed event - resets to page 1
class FilterPatientAppointmentsEvent extends PatientAppointmentEvent {
  final AppointmentStatusEnum? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const FilterPatientAppointmentsEvent({
    this.status,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [status, dateFrom, dateTo];
}

/// Clear all filters
class ClearFiltersPatientAppointmentsEvent extends PatientAppointmentEvent {
  const ClearFiltersPatientAppointmentsEvent();
}
