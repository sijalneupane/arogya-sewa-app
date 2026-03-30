import 'package:equatable/equatable.dart';
import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorEvent extends DoctorEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const FetchDoctorEvent({
    this.page = 1,
    this.size = 5,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });

  DoctorsQueryParamsEntity get queryParams => DoctorsQueryParamsEntity(
    page: page,
    size: size,
    name: name,
    departmentName: departmentName,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [
    page,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
  ];
}

class LoadMoreDoctorEvent extends DoctorEvent {
  final int currentPage;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const LoadMoreDoctorEvent({
    required this.currentPage,
    this.size = 10,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });

  DoctorsQueryParamsEntity get queryParams => DoctorsQueryParamsEntity(
    page: currentPage,
    size: size,
    name: name,
    departmentName: departmentName,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [
    currentPage,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
  ];
}

class RetryFetchDoctorEvent extends DoctorEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const RetryFetchDoctorEvent({
    this.page = 1,
    this.size = 5,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });

  @override
  List<Object?> get props => [
    page,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
  ];
}
