import 'package:equatable/equatable.dart';

/// Base class for all doctors events
abstract class DoctorsEvent extends Equatable {
  const DoctorsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch doctors list
class FetchDoctorsEvent extends DoctorsEvent {
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const FetchDoctorsEvent({
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });

  @override
  List<Object?> get props => [name, departmentId, freeUpcomingOnly];
}

/// Event to load more doctors (pagination)
class LoadMoreDoctorsEvent extends DoctorsEvent {
  final int currentPage;
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const LoadMoreDoctorsEvent({
    required this.currentPage,
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });

  @override
  List<Object?> get props => [currentPage, name, departmentId, freeUpcomingOnly];
}

/// Event to retry fetching doctors after error
class RetryFetchDoctorsEvent extends DoctorsEvent {
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const RetryFetchDoctorsEvent({
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });

  @override
  List<Object?> get props => [name, departmentId, freeUpcomingOnly];
}
