import 'package:equatable/equatable.dart';
import 'package:patient_app/features/home/domain/usecase/fetch_doctors_usecase.dart';

/// Base class for all doctors events
abstract class DoctorsEvent extends Equatable {
  const DoctorsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch doctors list
class FetchDoctorsEvent extends DoctorsEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const FetchDoctorsEvent({
    this.page = 1,
    this.size = 10,
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });

  FetchDoctorsParams get params => FetchDoctorsParams(
    page: page,
    size: size,
    name: name,
    departmentId: departmentId,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [page, size, name, departmentId, freeUpcomingOnly];
}

/// Event to load more doctors (pagination)
class LoadMoreDoctorsEvent extends DoctorsEvent {
  final int currentPage;
  final int size;
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const LoadMoreDoctorsEvent({
    required this.currentPage,
    this.size = 10,
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });

  FetchDoctorsParams get params => FetchDoctorsParams(
    page: currentPage,
    size: size,
    name: name,
    departmentId: departmentId,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [
    currentPage,
    size,
    name,
    departmentId,
    freeUpcomingOnly,
  ];
}

/// Event to retry fetching doctors after error
class RetryFetchDoctorsEvent extends DoctorsEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const RetryFetchDoctorsEvent({
    this.page = 1,
    this.size = 10,
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });

  FetchDoctorsParams get params => FetchDoctorsParams(
    page: page,
    size: size,
    name: name,
    departmentId: departmentId,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [page, size, name, departmentId, freeUpcomingOnly];
}
